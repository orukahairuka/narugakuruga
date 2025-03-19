//
//  DecibelsView.swift
//  narugakuruga
//
//  Created by 森田将嵩 on 2025/03/18.
//

import SwiftUI


struct DecibelsView: View {
    let mission: Mission
    @StateObject private var decibelViewModel = DecibelViewModel()
    @State var judgeScore = false

    var body: some View {
        VStack {
            if judgeScore {
                Text("お題クリア！")

                Button("報告する") {
                    missionVM.completeMission()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                Text("後ちょっと！")
            }
            Text("デシベル: \(String(format: "%.1f", decibelViewModel.decibels)) dB")
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
