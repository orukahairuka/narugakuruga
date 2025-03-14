//
//  HiderViewModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/14.
//

import CoreBluetooth
import AVFoundation
import SwiftUI

class HiderViewModel: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    private var peripheralManager: CBPeripheralManager!

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
        }
    }

    func stopAdvertising() {
        peripheralManager.stopAdvertising()
        print("Bluetooth広告を停止")
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("Bluetooth Peripheral is powered on.")
        } else {
            print("Bluetooth is not available.")
        }
    }
}
