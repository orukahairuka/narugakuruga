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
        Text("ミッション開始まで: \(timeRemaining) 秒")
            .font(.title2)
            .foregroundColor(.blue)
            .padding()
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(15)
    }
}

#Preview ("MissionCountdownView") {
    MissionCountdownView(timeRemaining: 30)
}
