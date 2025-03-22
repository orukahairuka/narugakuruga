//
//  ContentView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/13.
//

import SwiftUI
import FirebaseFirestore

// 画面状態を表す enum（グローバルで定義）
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
            switch currentScreen {
            case .roleSelect:
                RoleSelectionView(
                    seeker: seeker,
                    hider: hider,
                    playerName: $playerName,
                    currentScreen: $currentScreen
                )
            case .hider:
                HiderMainView(hider: hider)
            case .seeker:
                SeekerView(seeker: seeker)
            }
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
                LogoView()

                if !playerName.isEmpty {
                    Text("どちらか選んでください")
                        .foregroundColor(.gray)
                }

                TextField("ユーザー名を入力", text: $playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 300)

                HStack(spacing: 20) {
                    Button(action: {
                        guard !playerName.isEmpty else { return }
                        let shortUUID = seeker.getMyShortUUID()
                        let data: [String: Any] = [
                            "playerName": playerName
                        ]
                        Firestore.firestore().collection("players").document(shortUUID).setData(data) { error in
                            if error == nil {
                                seeker.startScanning()
                                hider.stopAdvertising()
                                currentScreen = .seeker
                            } else {
                                print("⚠️ 鬼のFirestore登録失敗: \(error!.localizedDescription)")
                            }
                        }
                    }) {
                        RoleButtonView(title: "鬼になる", color: .red)
                    }

                    Button(action: {
                        guard !playerName.isEmpty else { return }
                        let shortUUID = seeker.getMyShortUUID()
                        let data: [String: Any] = [
                            "playerName": playerName,
                            "role": "hider",
                            "joinedAt": Timestamp()
                        ]
                        Firestore.firestore().collection("players").document(shortUUID).setData(data) { error in
                            if error == nil {
                                hider.startAdvertising()
                                seeker.stopScanning()
                                currentScreen = .hider
                            } else {
                                print("⚠️ 隠れのFirestore登録失敗: \(error!.localizedDescription)")
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
