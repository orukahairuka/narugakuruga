//
//  MissionCompletedView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/19.
//

import SwiftUI

struct MissionCompleteView: View {
    @Binding var countdown: Int
    @Binding var showCountdown: Bool
    let onComplete: () -> Void

    var body: some View {
        VStack {
            Text("🎉 お題クリア！ 🎉")
                .font(.largeTitle)
                .foregroundColor(.green)
                .padding()

            if showCountdown {
                Text("次のお題まで: \(countdown)秒")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                Button("報告する") {
                    startCountdown()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }

    private func startCountdown() {
        showCountdown = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            countdown -= 1
            if countdown > 0 {
                startCountdown()
            } else {
                onComplete()
            }
        }
    }
}
