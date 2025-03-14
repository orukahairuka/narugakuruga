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
    @State private var isSeeker = false

    var body: some View {
        VStack {
            Text(isSeeker ? "鬼（探す側）" : "隠れる側")
                .font(.largeTitle)
                .padding()

            Button(action: {
                isSeeker.toggle()
                if isSeeker {
                    hider.stopAdvertising()
                    seeker.startScanning()
                    seeker.playSound()
                } else {
                    seeker.stopScanning()
                    hider.startAdvertising()
                }
            }) {
                Text(isSeeker ? "鬼になる" : "隠れる")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if isSeeker {
                List(seeker.discoveredPeripherals.keys.sorted(), id: \ .self) { id in
                    Text("発見: \(id) RSSI: \(seeker.discoveredPeripherals[id] ?? 0)")
                }
            }
        }
        .padding()
        .onAppear {
            requestBluetoothPermission()
        }
    }

    private func requestBluetoothPermission() {
        if let bundleID = Bundle.main.bundleIdentifier {
            print("Ensure Info.plist contains NSBluetoothAlwaysUsageDescription for app: \(bundleID)")
        }
    }
}
