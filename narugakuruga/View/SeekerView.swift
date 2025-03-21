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
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {
                Text("鬼の画面(わかるようにするLottieとか画像とか)")

                if seeker.isSeeking {
                    StatusTextView(text: "近くにいるプレイヤー")
                        .padding(.top)

                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(Array(peripherals.enumerated()), id: \.element.uuid) { _, item in
                                let playerName = seeker.playerNameMapping[item.uuid] ?? "Unknown"
                                PlayerInfoView(uuid: item.uuid, rssi: item.rssi, seeker: seeker, playerName: playerName)
                            }

                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct PlayerInfoView: View {
    let uuid: UUID
    let rssi: Int
    @ObservedObject var seeker: SeekerViewModel
    let playerName: String // ←追加

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("名前: \(playerName)")
                Text("UUID: \(uuid.uuidString)")
                Text("RSSI: \(rssi)")
            }
            .foregroundColor(.black)

            Spacer()

            CaptureButtonView(uuid: uuid, seeker: seeker, playerName: .constant(playerName))
        }
        .padding()
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}


struct CaptureButtonView: View {
    let uuid: UUID
    @ObservedObject var seeker: SeekerViewModel
    @Binding var playerName: String

    var body: some View {
        Button("捕まえた！") {
            let captureManager = PlayerCaptureManager()
            if let shortPlayerUUID = seeker.playerUUIDMapping[uuid] {
                print("🔥【鬼側】捕まえたプレイヤーの短縮UUIDは:", shortPlayerUUID)
                captureManager.recordCapturedPlayer(playerShortUUID: shortPlayerUUID, playerName: playerName) { error in
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
}
