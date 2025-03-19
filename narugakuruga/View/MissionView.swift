//
//  MissionView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/15.
//

import SwiftUI


enum MissionType: String {
    case walk, decibel, unknown
}

struct MissionView: View {
    @StateObject var missionVM = MissionViewModel()

    var body: some View {
        VStack {
            if let mission = missionVM.currentMission {
                Text("お題: \(mission.description)")
                    .font(.title)
                    .padding()

                MissionButton(mission: mission, missionVM: missionVM)
            } else {
                Text("お題を取得中...")
                    .font(.title2)
                    .padding()
            }
        }
    }
}

struct MissionButton: View {
    let mission: Mission
    @ObservedObject var missionVM: MissionViewModel

    var body: some View {
        switch MissionType(rawValue: mission.type) ?? .unknown {
        case .walk:
            NavigationLink(destination: WalkView(mission: mission, missionVM: missionVM)) {
                Text("歩数ミッションを開始")
                    .buttonStyle(PrimaryButtonStyle())
            }
        case .decibel:
            NavigationLink(destination: DecibelsView(mission: mission, missionVM: missionVM)) {
                Text("デシベルミッションを開始")
                    .buttonStyle(PrimaryButtonStyle())
            }
        default:
            EmptyView()
        }
    }
}
