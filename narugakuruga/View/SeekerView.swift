//
//  SeekerView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/17.
//

import SwiftUI

struct SeekerView: View {
    @ObservedObject var seeker: SeekerViewModel

    var peripherals: [(uuid: UUID, rssi: Int)] {
        seeker.discoveredPeripherals
            .map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1 }
    }

    var body: some View {
        VStack {
            Text("鬼の画面")
                .font(.largeTitle)
                .padding()

            if seeker.isSeeking {
                Text("近くにいるプレイヤー")
                    .font(.title2)
                    .padding(.top)

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(Array(peripherals.enumerated()), id: \.element.uuid) { _, item in
                            HStack {
                                Text("UUID: \(item.uuid.uuidString), RSSI: \(item.rssi)")
                                Spacer()

                                Button("捕まえた！") {
                                    let captureManager = PlayerCaptureManager()

                                    // ★ Peripheral UUID → Player短縮UUIDに変換
                                    if let shortPlayerUUID = seeker.playerUUIDMapping[item.uuid] {
                                        print("🔥【鬼側】捕まえたプレイヤーの短縮UUIDは:", shortPlayerUUID)
                                        captureManager.recordCapturedPlayer(playerShortUUID: shortPlayerUUID) { error in
                                            if let error = error {
                                                print("Firestore書き込みエラー:", error.localizedDescription)
                                            } else {
                                                print("Firestoreに書き込みました！（\(shortPlayerUUID)）")
                                            }
                                        }
                                    } else {
                                        print("⚠️プレイヤーの短縮UUIDが見つかりませんでした。")
                                    }
                                }
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }


                    }
                }
            }
        }
    }
}
