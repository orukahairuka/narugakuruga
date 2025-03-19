//
//  MissionView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/15.
//

import SwiftUI

import SwiftUI

struct MissionView: View {
    @StateObject var missionVM = MissionViewModel()

    var body: some View {
        VStack {
            if let mission = missionVM.currentMission {
                Text("お題: \(mission.description)")
                    .font(.title)
                    .padding()

                if mission.type == "walk" {
                    NavigationLink(destination: WalkView(mission: mission)) {
                        Text("歩数ミッションを開始")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else if mission.type == "decibel" {
                    NavigationLink(destination: DecibelsView(mission: mission)) {
                        Text("デシベルミッションを開始")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            } else {
                Text("お題を取得中...")
                    .font(.title2)
                    .padding()
            }
        }
    }
}
