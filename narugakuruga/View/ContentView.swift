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
}

struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "#C6E7FF"), Color(hex: "#A8E6CF")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct LogoView: View {
    var body: some View {
        Text("かくれんぼアプリ")
            .font(.largeTitle)
            .foregroundColor(.white)
            .shadow(radius: 5)
    }
}

struct StatusTextView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.black.opacity(0.8))
            .padding()
            .cornerRadius(15)
            .padding(.horizontal)
    }
}

struct MissionCountdownView: View {
    let timeRemaining: Int

    var body: some View {
        Text("ミッション開始まで: \(timeRemaining) 秒")
            .font(.title2)
            .foregroundColor(.blue)
            .padding()
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(15)
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

#Preview ("BackgroundView") {
    BackgroundView()
}

#Preview ("LogoView") {
    LogoView()
}

#Preview ("StatusTextView") {
    StatusTextView(text: "鬼になりました")
}

#Preview ("MissionCountdownView") {
    MissionCountdownView(timeRemaining: 30)
}

#Preview ("RoleButtonView") {
    RoleButtonView(title: "鬼になる", color: .red)
}
