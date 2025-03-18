//
//  MissionView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/15.
//

import SwiftUI

struct MissionView: View {
    @StateObject var missionVM = MissionViewModel()
    @StateObject var stepTrackerVM: StepTrackerViewModel

    init() {
        let initialGoal = 10
        _stepTrackerVM = StateObject(wrappedValue: StepTrackerViewModel(goalSteps: initialGoal))
    }

    var body: some View {
        VStack {
            if let mission = missionVM.currentMission {
                Text("お題: \(mission.description)")
                    .font(.title)
                    .padding()

                if mission.type == "walk" {
                    Text("現在の歩数: \(stepTrackerVM.stepsTaken) / \(mission.goal)")
                        .font(.headline)
                } else if mission.type == "decibel" {
                    Text("現在のデシベル: \(mission.goal)")
                        .font(.headline)
                }

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
            } else {
                Text("お題を取得中...")
                    .font(.title2)
                    .padding()
            }
        }
    }
}
