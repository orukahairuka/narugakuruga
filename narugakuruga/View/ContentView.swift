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
            VStack {
                Text("かくれんぼアプリ")
                    .font(.largeTitle)
                    .padding()

                Text(statusText)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()

                if hider.isHiding {
                    Text("ミッション開始まで: \(hider.timeRemaining) 秒")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                }

                NavigationLink(destination: MissionView(), isActive: $hider.navigateToMission) {
                    EmptyView()
                }

                HStack {
                    NavigationLink(destination: SeekerView(seeker: seeker)) {
                        Text("鬼になる")
                            .font(.title)
                            .padding()
                            .background(seeker.isSeeking ? Color.red.opacity(0.7) : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        seeker.startScanning()
                        hider.stopAdvertising()
                    })

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
}
