//
//  SeekerViewModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/14.
//

import CoreBluetooth
import AVFoundation
import SwiftUI

// 鬼（探す側）
class SeekerViewModel: NSObject, ObservableObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager!
    private var audioPlayer: AVAudioPlayer?
    @Published var discoveredPeripherals: [UUID: Int] = [:]

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        centralManager.scanForPeripherals(withServices: [CBUUID(string: "1234")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    func stopScanning() {
        centralManager.stopScan()
    }

    //central.stateを確認して、BluetoothがpoweredOn時print文を表示
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth Central is powered on.")
        } else {
            print("Bluetooth is not available.")
        }
    }

    //CBCentralManager が scanForPeripherals でデバイスを発見すると呼ばれる
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("発見: \(peripheral.identifier), RSSI: \(RSSI)")
        discoveredPeripherals[peripheral.identifier] = RSSI.intValue
        adjustVolumeBasedOnRSSI(RSSI.intValue)
    }

    private func adjustVolumeBasedOnRSSI(_ rssi: Int) {
        // RSSIの影響を逆転させ、近づくと音が大きくなるように調整
        let normalizedRSSI = max(-90, min(-30, rssi)) // -90 〜 -30 の範囲に制限
        let distanceFactor = ((Double(normalizedRSSI) + 90) / 60) // -90 (遠) → 0.0, -30 (近) → 1.0
        let volume = Float(distanceFactor * distanceFactor) // 近づくほど急に大きく
        print("調整後の音量: \(volume)")
        audioPlayer?.volume = volume
    }

    func playSound() {
        if let url = Bundle.main.url(forResource: "seek_sound", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            } catch {
                print("Error loading sound file: \(error.localizedDescription)")
            }
        }
    }
}
