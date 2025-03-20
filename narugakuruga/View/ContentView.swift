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
            VStack {
                Text("かくれんぼアプリ")
                    .font(.largeTitle)
                    .padding()

                Text(statusText)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()

                // カウントダウン表示
                if isWaitingForSeeker {
                    Text("鬼になるまで: \(remainingTimeForSeeker) 秒")
                        .font(.title2)
                        .foregroundColor(.red)
                        .padding()
                }

                NavigationLink(destination: SeekerView(seeker: seeker), isActive: $navigateToSeeker) {
                    EmptyView()
                }

                HStack {
                    if isWaitingForSeeker {
                        // 「鬼になる」ボタンを無効化
                        Text("鬼になる")
                            .font(.title)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    } else {
                        Button(action: startSeekerCountdown) {
                            Text("鬼になる")
                                .font(.title)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }

                    NavigationLink(destination: HiderView(hider: hider)) {
                        Text("隠れる")
                            .font(.title)
                            .padding()
                            .background(hider.isHiding ? Color.blue.opacity(0.7) : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        hider.startAdvertising()
                        seeker.stopScanning()
                    })
                    .padding()
                }
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
