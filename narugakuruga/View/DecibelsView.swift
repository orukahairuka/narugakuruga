//
//  DecibelsView.swift
//  narugakuruga
//
//  Created by 森田将嵩 on 2025/03/18.
//

import SwiftUI

struct DecibelsView: View {
    let mission: Mission
    @ObservedObject var missionVM: MissionViewModel
    @StateObject private var decibelViewModel = DecibelViewModel()
    @State private var judgeScore = false
    @State private var showCountdown = false
    @State private var countdown = 60

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {
                if judgeScore {
                    MissionCompleteView(
                        countdown: $countdown,
                        showCountdown: $showCountdown,
                        onComplete: {
                            missionVM.completeMission()
                        }
                    )
                } else {
                    StatusTextView(text: "後ちょっと！", color: .orange)
                }

                StatusTextView(text: "デシベル: \(String(format: "%.1f", decibelViewModel.decibels)) dB", color: .black)
                    .padding()

                Button(action: {
                    if decibelViewModel.isRecording {
                        decibelViewModel.stopRecording()
                    } else {
                        decibelViewModel.startRecording()
                    }
                }) {
                    RoleButtonView(title: decibelViewModel.isRecording ? "停止" : "計測開始", color: decibelViewModel.isRecording ? .red : .blue)
                        .frame(width: 200, height: 50)
                        .padding(.bottom, 70)
                }
                .onChange(of: decibelViewModel.decibels) {
                    judgeScore = decibelViewModel.decibels > Float(mission.goal)
                }
            }
        }
    }
}
