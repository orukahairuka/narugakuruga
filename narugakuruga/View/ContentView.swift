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

                Text(getStatusText())
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()

                NavigationLink(destination: MissionView(), isActive: $hider.navigateToMission) {
                    EmptyView()
                }

                HStack {
                    Button(action: {
                        seeker.startScanning()
                        hider.stopAdvertising()
                    }) {
                        Text("鬼になる")
                            .font(.title)
                            .padding()
                            .background(seeker.isSeeking ? Color.red.opacity(0.7) : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        hider.startAdvertising()
                        seeker.stopScanning()
                    }) {
                        Text("隠れる")
                            .font(.title)
                            .padding()
                            .background(hider.isHiding ? Color.blue.opacity(0.7) : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()

                if seeker.isSeeking {
                    Text("発見したプレイヤー")
                        .font(.title2)
                        .padding(.top)
                    List(seeker.discoveredPeripherals.keys.sorted(), id: \ .self) { id in
                        Text("UUID: \(id) - RSSI: \(seeker.discoveredPeripherals[id] ?? 0)")
                    }
                }
            }
        }
    }
    //可読性を上げるためのテキストメソッド
    private func getStatusText() -> String {
            if seeker.isSeeking {
                return "鬼になりました"
            } else if hider.isHiding {
                return "隠れています"
            } else {
                return "どちらか選んでください"
            }
        }
}
