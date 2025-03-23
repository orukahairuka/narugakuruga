//
//  ContentView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/13.
//

import SwiftUI
import FirebaseFirestore

enum GameScreen {
    case roleSelect
    case hider
    case seeker
}

struct ContentView: View {
    @State private var currentScreen: GameScreen = .roleSelect
    @StateObject private var seeker = SeekerViewModel()
    @StateObject private var hider = HiderViewModel()
    @State private var playerName: String = ""

    var body: some View {
        ZStack {
            BackgroundView()

            switch currentScreen {
            case .roleSelect:
                VStack(spacing: 20) {

                    if hider.isHiding {
                        MissionCountdownView(timeRemaining: hider.timeRemaining)
                    }

                    RoleSelectionView(
                        seeker: seeker,
                        hider: hider,
                        playerName: $playerName,
                        currentScreen: $currentScreen
                    )
                }
                .padding()

            case .hider:
                HiderMainView(hider: hider)

            case .seeker:
                SeekerView(seeker: seeker)
            }
        }
    }

    private var statusText: String {
        if seeker.isSeeking {
            return "鬼になりました"
        } else if hider.isHiding {
            return "隠れています"
        } else {
            return "どちらか選んでください"
        }
    }
}

struct RoleSelectionView: View {
    @ObservedObject var seeker: SeekerViewModel
    @ObservedObject var hider: HiderViewModel
    @Binding var playerName: String
    @Binding var currentScreen: GameScreen

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {
                Loop_Lottie_View(name: "Seeker2")

                if !playerName.isEmpty {
                    Text("どちらか選んでください")
                        .foregroundColor(.gray)
                }

                TextField("ユーザー名を入力", text: $playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 300)

                HStack(spacing: 20) {
                    // 鬼になる
                    Button(action: {
                        guard !playerName.isEmpty else { return }

                        let shortUUID = seeker.getMyShortUUID()
                        let data: [String: Any] = [
                            "playerName": playerName,
                            "role": "seeker",
                            "joinedAt": Timestamp()
                        ]
                        Firestore.firestore().collection("players").document(shortUUID).setData(data) { error in
                            if let error = error {
                                print("⚠️ 鬼のFirestore登録失敗: \(error.localizedDescription)")
                            } else {
                                seeker.startScanning()
                                hider.stopAdvertising()
                                currentScreen = .seeker
                            }
                        }
                    }) {
                        RoleButtonView(title: "鬼になる", color: .red)
                    }

                    // 隠れる
                    Button(action: {
                        guard !playerName.isEmpty else { return }

                        let shortUUID = seeker.getMyShortUUID()
                        let data: [String: Any] = [
                            "playerName": playerName,
                            "role": "hider",
                            "joinedAt": Timestamp()
                        ]
                        Firestore.firestore().collection("players").document(shortUUID).setData(data) { error in
                            if let error = error {
                                print("⚠️ 隠れのFirestore登録失敗: \(error.localizedDescription)")
                            } else {
                                hider.startAdvertising()
                                seeker.stopScanning()
                                currentScreen = .hider
                            }
                        }
                    }) {
                        RoleButtonView(title: "隠れる", color: .blue)
                    }
                }
                .padding()
            }
        }
    }
}

struct RoleButtonView: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.title)
            .padding()
            .frame(maxWidth: .infinity)
            .background(BlurView(style: .systemUltraThinMaterialDark))
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(color, lineWidth: 2))
            .foregroundColor(.white)
    }
}
