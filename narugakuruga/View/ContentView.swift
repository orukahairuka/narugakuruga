//
//  ContentView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/13.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var seeker = SeekerViewModel()
    @StateObject private var hider = HiderViewModel()

    @State private var isWaitingForSeeker = false // 鬼になるまでのカウントダウン中かどうか
    @State private var remainingTimeForSeeker = 40 // 鬼になるまでの残り時間
    @State private var navigateToSeeker = false // 鬼になったらSeekerViewに遷移するかどうか

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack(spacing: 20) {
                    LogoView()
                    StatusTextView(text: statusText)
                    if hider.isHiding {
                        MissionCountdownView(timeRemaining: hider.timeRemaining)
                    }
                    NavigationLink(destination: MissionView(), isActive: $hider.navigateToMission) {
                        EmptyView()
                    }
                    RoleSelectionView(seeker: seeker, hider: hider)
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

    var body: some View {
        HStack(spacing: 20) {
            NavigationLink(destination: SeekerView(seeker: seeker)) {
                RoleButtonView(title: "鬼になる", color: .red)
            }
            .simultaneousGesture(TapGesture().onEnded {
                seeker.startScanning()
                hider.stopAdvertising()
            })

            NavigationLink(destination: HiderView(hider: hider)) {
                RoleButtonView(title: "隠れる", color: .blue)
            }
            .simultaneousGesture(TapGesture().onEnded {
                hider.startAdvertising()
                seeker.stopScanning()
            })
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
