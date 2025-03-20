//
//  WalkView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/19.
//

import SwiftUI

struct WalkView: View {
    let mission: Mission
    @ObservedObject var missionVM: MissionViewModel
    @StateObject var stepTrackerVM = StepTrackerViewModel(goalSteps: 10)
    @State private var showCountdown = false
    @State private var countdown = 60

    var body: some View {
        VStack {
            Text("現在の歩数: \(stepTrackerVM.stepsTaken) / \(mission.goal)")
                .font(.headline)

            if stepTrackerVM.isMissionCompleted() {
                MissionCompleteView(
                    countdown: $countdown,
                    showCountdown: $showCountdown,
                    onComplete: {
                        missionVM.completeMission()
                    }
                )
            }
        }
    }
}
