//
//  DecibelsView.swift
//  narugakuruga
//
//  Created by 森田将嵩 on 2025/03/18.
//

import SwiftUI


import SwiftUI

struct DecibelsView: View {
    let mission: Mission
    @ObservedObject var missionVM: MissionViewModel
    @StateObject private var decibelViewModel = DecibelViewModel()
    @State private var judgeScore = false
    @State private var showCountdown = false
    @State private var countdown = 60

    var body: some View {
        VStack {
            if judgeScore {
                MissionCompleteView(
                    countdown: $countdown,
                    showCountdown: $showCountdown,
                    onComplete: {
                        missionVM.completeMission()
                    }
                )
            } else {
                Text("後ちょっと！")
                    .font(.headline)
                    .foregroundColor(.orange)
                    .padding()
            }

            Text("デシベル: \(String(format: "%.1f", decibelViewModel.decibels)) dB")
                .font(.title)
                .padding()

            Button(action: {
                if decibelViewModel.isRecording {
                    decibelViewModel.stopRecording()
                } else {
                    decibelViewModel.startRecording()
                }
            }) {
                Text(decibelViewModel.isRecording ? "停止" : "計測開始")
                    .font(.title)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(decibelViewModel.isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onChange(of: decibelViewModel.decibels) {
                judgeScore = decibelViewModel.decibels > Float(mission.goal)
            }
        }
    }
}
