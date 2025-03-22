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
    @ObservedObject var hider: HiderViewModel

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {
                if let missionVM = hider.missionVM {
                    if missionVM.gameWon {
                        GameWinView()
                    } else if let mission = missionVM.currentMission {
                        StatusTextView(text: "お題: \(mission.description)")

                        Button("ミッション開始") {
                            hider.startMission(mission)
                        }

                        StatusTextView(
                            text: "クリア数: \(missionVM.completedMissionsCount) / 4",
                            color: .gray
                        )
                    } else {
                        StatusTextView(text: "お題を取得中…")
                    }
                } else {
                    ProgressView("ミッション読み込み中…")
                }

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
                RoleButtonView(title: "歩数ミッションを開始", color: .blue)
            }
        case .decibel:
            NavigationLink(destination: DecibelsView(mission: mission, missionVM: missionVM)) {
                RoleButtonView(title: "デシベルミッションを開始", color: .blue)
            }
        default:
            EmptyView()
        }
    }
}
