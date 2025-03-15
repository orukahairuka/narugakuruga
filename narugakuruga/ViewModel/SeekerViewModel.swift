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
    @Published var isSeeking = false

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        setupAudio()
    }

    func startScanning() {
        centralManager.scanForPeripherals(withServices: [CBUUID(string: "1234")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        isSeeking = true
    }

    func stopScanning() {
        centralManager.stopScan()
        stopSound()
        isSeeking = false
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth Central is powered on.")
        } else {
            print("Bluetooth is not available.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("発見: \(peripheral.identifier), RSSI: \(RSSI)")
        discoveredPeripherals[peripheral.identifier] = RSSI.intValue
        playSound()
        adjustVolumeBasedOnRSSI(RSSI.intValue)
    }

    private func adjustVolumeBasedOnRSSI(_ rssi: Int) {
        let normalizedRSSI = max(-90, min(-30, rssi))
        let distanceFactor = ((Double(normalizedRSSI) + 90) / 60)
        let volume = Float(distanceFactor * distanceFactor)
        print("調整後の音量: \(volume)")
        audioPlayer?.volume = volume
    }

    private func setupAudio() {
        if let url = Bundle.main.url(forResource: "seek_sound", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.volume = 0.0
            } catch {
                print("Error loading sound file: \(error.localizedDescription)")
            }
        }
    }

    func playSound() {
        if let player = audioPlayer, !player.isPlaying {
            player.play()
        }
    }

    func stopSound() {
        audioPlayer?.stop()
    }
}
