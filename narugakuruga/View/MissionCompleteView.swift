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
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {
                StatusTextView(text: "🎉 お題クリア！ 🎉", color: .green)

                if showCountdown {
                    StatusTextView(text: "次のお題まで: \(countdown)秒", color: .gray)
                } else {
                    Button("報告する") {
                        startCountdown()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            Lottie_View(name: "Check")
                .allowsHitTesting(false)
            Lottie_View(name: "Party")
                .allowsHitTesting(false)
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
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
