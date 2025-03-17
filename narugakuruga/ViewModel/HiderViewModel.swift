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



    override init() {
        self.captureManager = PlayerCaptureManager() // ←ここで初期化する
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        observeCaughtStatus()
    }

    deinit {
        caughtListener?.remove()
    }

    // 自分が捕まったかどうかを監視
        private func observeCaughtStatus() {
            guard let myID = UIDevice.current.identifierForVendor else { return }

            caughtListener = captureManager.listenIfCaught(playerID: myID) { [weak self] in
                DispatchQueue.main.async {
                    self?.caught = true
                    print("自分が捕まった！")
                    // 他に必要な処理
                }
            }
        }

    func startAdvertising() {
        if peripheralManager.state == .poweredOn {
            let advertisementData: [String: Any] = [
                CBAdvertisementDataLocalNameKey: "Hider",
                CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "1234")]
            ]
            print("Bluetooth広告を開始")
            peripheralManager.startAdvertising(advertisementData)
            isHiding = true
            // 1分後にミッション画面へ遷移
            startMissionTimer()
        }
    }

    func stopAdvertising() {
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
