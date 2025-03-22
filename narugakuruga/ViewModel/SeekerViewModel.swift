//
//  SeekerViewModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/14.
//

import CoreBluetooth
import AVFoundation
import SwiftUI
import FirebaseFirestore

// 鬼（探す側）
class SeekerViewModel: NSObject, ObservableObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager!
    private var audioPlayer: AVAudioPlayer?
    @Published var discoveredPeripherals: [UUID: Int] = [:]
    @Published var playerUUIDMapping: [UUID: String] = [:]  // PeripheralのUUID → Playerの短縮UUID
    @Published var playerNameMapping: [UUID: String] = [:] // ←これを新しく追加

    @Published var playerName: String = ""
    @Published var isSeeking = false
    private let db = Firestore.firestore()
    private let captureManager = PlayerCaptureManager()
        @Published var isCaught = false //プレイヤーを捕まえたかどうか

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        setupAudio()
    }

    func startScanning() {
        self.playerName = playerName
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

    func updatePlayerName(for uuid: UUID) {
        guard let shortUUID = playerUUIDMapping[uuid] else {
            print("⚠️ shortUUID が見つかりません")
            return
        }

        let db = Firestore.firestore()
        db.collection("players").document(shortUUID).getDocument { snapshot, error in
            if let error = error {
                print("🔥 名前取得失敗: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data(), let name = data["playerName"] as? String {
                DispatchQueue.main.async {
                    self.playerNameMapping[uuid] = name
                    print("✅ プレイヤー名取得成功: \(name)")
                }
            } else {
                print("⚠️ プレイヤー名が存在しません")
            }
        }
    }



    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {

        discoveredPeripherals[peripheral.identifier] = RSSI.intValue
        print("発見 Peripheral ID:", peripheral.identifier, "RSSI:", RSSI)

        if let fullUUIDString = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            let shortPlayerUUID = String(fullUUIDString.prefix(8))
            print("✅広告データで受け取った短縮UUID:", shortPlayerUUID)

            // PeripheralのUUIDとプレイヤーの短縮UUIDをマッピングする
            playerUUIDMapping[peripheral.identifier] = shortPlayerUUID
        } else {
            print("⚠️ 広告データにUUIDなし:", advertisementData)
        }

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

extension SeekerViewModel {
    func getMyShortUUID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString.prefix(8).description ?? UUID().uuidString.prefix(8).description
    }
}
