//
//  MissionCountdownView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/20.
//

import SwiftUI

struct MissionCountdownView: View {
    let timeRemaining: Int

    var body: some View {
        VStack {
            Loop_Lottie_View(name: "Timer")
            Text("ミッション開始まで: \(timeRemaining) 秒")
                .font(.title)
                .foregroundColor(.blue)
                .padding()
        }

    }
}

#Preview ("MissionCountdownView") {
    MissionCountdownView(timeRemaining: 30)
}
