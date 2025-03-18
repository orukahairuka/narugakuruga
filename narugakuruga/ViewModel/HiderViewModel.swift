//
//  HiderViewModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/14.
//

import CoreBluetooth
import AVFoundation
import SwiftUI
import FirebaseFirestore

// 隠れる側（プレイヤー）
class HiderViewModel: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    @Published var isHiding = false //自分がプレイヤーかどうか
    @Published var navigateToMission = false
    @Published var timeRemaining: Int = 40 //ミッション開始までの時間
    @Published var discoveredPeripherals: [UUID: Int] = [:] //周囲の端末
    @Published var caught = false  //自分が捕まったかどうか


    private let captureManager: PlayerCaptureManager
    private var peripheralManager: CBPeripheralManager!
    private var missionTimer: Timer?
    private var caughtListener: ListenerRegistration?
    private let db = Firestore.firestore()



    override init() {
        self.captureManager = PlayerCaptureManager() // ←ここで初期化する
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    deinit {
        caughtListener?.remove()
    }

    func observeCaughtStatus() {
        guard let myID = UIDevice.current.identifierForVendor else { return }
        let shortUUID = String(myID.uuidString.prefix(8)) // 先頭8文字を使う

        print("【プレイヤー側】監視する短縮UUIDは", shortUUID)

        // ★ 既存のリスナーを削除してから新規リスナーを登録する
        captureManager.stopListeningCaptured()

        captureManager.startListeningCaptured(playerShortUUID: shortUUID) { [weak self] in
            DispatchQueue.main.async {
                self?.caught = true
                // ✅ ここではログを出さずに `startListeningCaptured()` に任せる
            }
        }
    }



    // captureManagerの方も短縮UUIDを受け取れるように修正



    func startAdvertising() {
        guard peripheralManager.state == .poweredOn else { return }
        guard let myID = UIDevice.current.identifierForVendor else { return }

        // 必ず先頭8文字だけを送信
        let shortUUID = String(myID.uuidString.prefix(8))

        let advertisementData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: shortUUID, // ←これで統一
            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "1234")]
        ]

        peripheralManager.startAdvertising(advertisementData)
        print("プレイヤーが送信する短縮UUID:", shortUUID)
        isHiding = true
        observeCaughtStatus()
        startMissionTimer()
    }




    func stopAdvertising() {
        //捕まったかどうかの監視を停止する
        captureManager.stopListeningCaptured()
        peripheralManager.stopAdvertising()
        print("Bluetooth広告を停止")
        isHiding = false
        navigateToMission = false
        missionTimer?.invalidate() // タイマーをキャンセル
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("Bluetooth Peripheral is powered on.")
        } else {
            print("Bluetooth is not available.")
        }
    }

    //開始一分後にミッション画面に遷移するためのタイマー
    private func startMissionTimer() {
        missionTimer?.invalidate()
        timeRemaining = 40
        missionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            DispatchQueue.main.async {
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    timer.invalidate()
                    self.navigateToMission = true
                }
            }
        }
    }
}
