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
    @Published var isHiding = false //自分がプレイヤーかどうか(画面遷移のためのフラグ)
    @Published var navigateToMission = false
    @Published var timeRemaining: Int = 40 //ミッション開始までの時間
    @Published var discoveredPeripherals: [UUID: Int] = [:] //周囲の端末
    @Published var caught = false  //自分が捕まったかどうか
    @Published var caughtPlayerUUID: String?  //誰が捕まったか


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

    //だれかが捕まったことを全プレイヤーに通知する
    func observeAllCaughtPlayers() {
        captureManager.startListeningAllCapturedPlayers { [weak self] playerUUID in
            DispatchQueue.main.async {
                self?.caughtPlayerUUID = playerUUID
                print("📢 全プレイヤーに通知: \(playerUUID) が捕まった！")
                self?.announceCaughtPlayer(playerUUID)
            }
        }
    }

    //捕まったプレイヤーを通知する
    private func announceCaughtPlayer(_ playerUUID: String) {
        // UIに通知する処理（アラートなど）
        if playerUUID == self.myShortUUID() {
            self.caught = true
        } else {
            print("📢 他のプレイヤーが捕まりました: \(playerUUID)")
        }
    }

    private func myShortUUID() -> String {
        guard let myID = UIDevice.current.identifierForVendor else { return "" }
        return String(myID.uuidString.prefix(8))
    }

    //捕まったことを監視してUIを更新する
    func observeCaughtStatus() {
        guard let myID = UIDevice.current.identifierForVendor else { return }
        let shortUUID = String(myID.uuidString.prefix(8)) // 先頭8文字を使う

        print("【プレイヤー側】監視する短縮UUIDは", shortUUID)

        // ★ 既存のリスナーを削除してから新規リスナーを登録する
        captureManager.stopListeningCaptured()

        captureManager.startListeningCaptured(playerShortUUID: shortUUID) { [weak self] in
            DispatchQueue.main.async {
                self?.caught = true //UIを更新
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

        // ★ ここで捕獲状態をリセット（Firestore & ローカル両方）
        resetCaughtStatus()

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

    //プレイヤーが「隠れる」ボタンを押したら捕まった状態をリセットするための関数
    func resetCaughtStatus() {
        guard let myID = UIDevice.current.identifierForVendor else { return }
        let shortUUID = String(myID.uuidString.prefix(8))

        print("【プレイヤー側】Firestoreの捕獲状態をリセット:", shortUUID)

        // Firestoreのデータを削除する場合（ドキュメントごと消す）
        db.collection("caughtPlayers").document(shortUUID).delete { error in
            if let error = error {
                print("Firestoreの削除エラー:", error.localizedDescription)
            } else {
                print("Firestoreのデータをリセットしました")
            }
        }

        // ローカルの状態もリセット
        DispatchQueue.main.async {
            self.caught = false
        }
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
