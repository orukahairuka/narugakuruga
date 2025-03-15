//
//  HiderViewModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/14.
//

import CoreBluetooth
import AVFoundation
import SwiftUI

// 隠れる側（プレイヤー）
class HiderViewModel: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    private var peripheralManager: CBPeripheralManager!
    @Published var isHiding = false
    @Published var navigateToMission = false
    private var missionTimer: Timer?

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
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
        missionTimer?.invalidate() // 既存のタイマーがあればキャンセル
        missionTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { _ in
            DispatchQueue.main.async {
                self.navigateToMission = true
            }
        }
    }
}
