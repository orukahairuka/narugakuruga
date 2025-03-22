//
//  HiderView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/17.
//

import SwiftUI

struct HiderMainView: View {
    @StateObject var hider: HiderViewModel
    var body: some View {
        VStack {
            HiderView(hider: hider)
            HiderMapView()
        }
    }
}

struct HiderMapView: View {
    var body: some View {
        VStack {
            Text("隠れる側のマップ")
        }
    }
}

struct HiderView: View {
    @ObservedObject var hider: HiderViewModel

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {
                Text("隠れる側の画面(わかるようにするLottieとか画像とか)")

                if hider.isHiding {
                    MissionCountdownView(timeRemaining: hider.timeRemaining)
                }

                if hider.caught {
                    StatusTextView(text: "あなたは捕まりました！", color: .red)
                } else {
                    StatusTextView(text: "あなたは隠れています", color: .green)
                }

                if let caughtPlayer = hider.caughtPlayerName {
                    StatusTextView(text: "\(caughtPlayer) が捕まりました！", color: .red)
                        .transition(.opacity)
                        .animation(.easeInOut, value: caughtPlayer)
                }

                NavigationLink(destination: MissionView(), isActive: $hider.navigateToMission) {
                    EmptyView()
                }
            }
        }
        .onAppear {
            hider.observeAllCaughtPlayers()
        }
    }
}
