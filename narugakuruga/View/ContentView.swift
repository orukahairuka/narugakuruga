//
//  ContentView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/13.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @StateObject private var seeker = SeekerViewModel()
    @StateObject private var hider = HiderViewModel()

    @State private var isWaitingForSeeker = false // 鬼になるまでのカウントダウン中かどうか
    @State private var remainingTimeForSeeker = 40 // 鬼になるまでの残り時間
    @State private var navigateToSeeker = false // 鬼になったらSeekerViewに遷移するかどうか
    @State private var playerName: String = "" // ユーザー名


    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack(spacing: 20) {
                    LogoView()
                    if playerName != "" {
                        StatusTextView(text: statusText)
                    }

                    // ユーザー名入力欄
                    TextField("ユーザー名を入力", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(width: 300)
                    if hider.isHiding {
                        MissionCountdownView(timeRemaining: hider.timeRemaining)
                    }
                    NavigationLink(destination: MissionView(), isActive: $hider.navigateToMission) {
                        EmptyView()
                    }
                    if playerName != ""{

                        RoleSelectionView(seeker: seeker, hider: hider, playerName: $playerName)
                    } else {
                        Text("ユーザー名を入力してください")
                            .foregroundColor(.red)
                    }
                }
                .padding()
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

    // 鬼になるカウントダウンを開始する
    private func startSeekerCountdown() {
        isWaitingForSeeker = true
        remainingTimeForSeeker = 40

        for i in 1...40 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                remainingTimeForSeeker -= 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 40) {
            navigateToSeeker = true
            seeker.startScanning()
            hider.stopAdvertising()
        }
    }
}

struct RoleSelectionView: View {
    @ObservedObject var seeker: SeekerViewModel
    @ObservedObject var hider: HiderViewModel
    @Binding var playerName: String

    @State private var isNavigatingToSeeker = false
    @State private var isNavigatingToHider = false

    var body: some View {
        HStack(spacing: 20) {
            NavigationLink(destination: SeekerView(seeker: seeker), isActive: $isNavigatingToSeeker) {
                EmptyView()
            }

            NavigationLink(destination: HiderMainView(hider: hider), isActive: $isNavigatingToHider) {
                EmptyView()
            }


            Button(action: {
                guard !playerName.isEmpty else { return }
                let shortUUID = seeker.getMyShortUUID()
                let data: [String: Any] = [
                    "playerName": playerName
                ]
                let db = Firestore.firestore()
                db.collection("players").document(shortUUID).setData(data) { error in
                    if let error = error {
                        print("⚠️ Firestore書き込み失敗（鬼）:", error.localizedDescription)
                    } else {
                        print("✅ 鬼として登録完了: \(playerName)")
                        seeker.startScanning()
                        hider.stopAdvertising()
                        isNavigatingToSeeker = true
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

                let db = Firestore.firestore()
                db.collection("players").document(shortUUID).setData(data) { error in
                    if let error = error {
                        print("⚠️ Firestore書き込み失敗（隠れ）:", error.localizedDescription)
                    } else {
                        print("✅ 隠れとして登録完了: \(playerName)")
                        hider.startAdvertising()
                        seeker.stopScanning()
                        isNavigatingToHider = true
                    }
                }
            }) {
                RoleButtonView(title: "隠れる", color: .blue)
            }
        }
        .padding()
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
