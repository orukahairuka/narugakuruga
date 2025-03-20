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
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#C6E7FF"), Color(hex: "#A8E6CF")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {

                    //ここのタイトルにロゴ配置後で
                    Text("かくれんぼアプリ")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    Text(statusText)
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.8))
                        .padding()
                        .cornerRadius(15)
                        .padding(.horizontal)

                    if hider.isHiding {
                        Text("ミッション開始まで: \(hider.timeRemaining) 秒")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .padding()
                            .background(BlurView(style: .systemMaterial))
                            .cornerRadius(15)
                    }

                    NavigationLink(destination: MissionView(), isActive: $hider.navigateToMission) {
                        EmptyView()
                    }

                    HStack(spacing: 20) {
                        NavigationLink(destination: SeekerView(seeker: seeker)) {
                            Text("鬼になる")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(BlurView(style: .systemUltraThinMaterialDark))
                                .cornerRadius(15)
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.red, lineWidth: 2))
                                .foregroundColor(.white)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            seeker.startScanning()
                            hider.stopAdvertising()
                        })

                        NavigationLink(destination: HiderView(hider: hider)) {
                            Text("隠れる")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(BlurView(style: .systemUltraThinMaterialDark))
                                .cornerRadius(15)
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 2))
                                .foregroundColor(.white)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            hider.startAdvertising()
                            seeker.stopScanning()
                        })
                    }
                    .padding()
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



