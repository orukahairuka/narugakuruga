//
//  StepTrackViewModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/15.
//

import CoreMotion
import SwiftUI

class StepTrackerViewModel: ObservableObject {
    private let pedometer = CMPedometer()
    @Published var stepsTaken: Int = 0
    var goalSteps: Int?

    init(goalSteps: Int?) {
        self.goalSteps = goalSteps
        startTrackingSteps()
    }

    // 歩数カウントを開始
    func startTrackingSteps() {
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { data, error in
                if let stepCount = data?.numberOfSteps.intValue {
                    DispatchQueue.main.async {
                        self.stepsTaken = stepCount
                    }
                }
            }
        }
    }

    // お題を達成したかチェック
    func isMissionCompleted() -> Bool {
        guard let goal = goalSteps else { return false }
        return stepsTaken >= goal
    }
}
