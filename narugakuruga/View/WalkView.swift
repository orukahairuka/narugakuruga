//
//  WalkView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/19.
//

import SwiftUI

struct WalkView: View {
    let mission: Mission
    @StateObject var stepTrackerVM = StepTrackerViewModel(goalSteps: 10)

    var body: some View {
        VStack {
            Text("現在の歩数: \(stepTrackerVM.stepsTaken) / \(mission.goal)")
                .font(.headline)

            if stepTrackerVM.isMissionCompleted() {
                Text("🎉 お題クリア！ 🎉")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .padding()

                Button("報告する") {
                    missionVM.completeMission()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}
