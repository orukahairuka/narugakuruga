//
//  b.swift
//  narugakuruga
//
//  Created by 森田将嵩 on 2025/03/22.
//
import SwiftUI

struct HiderMainView: View {
    @StateObject var hider: HiderViewModel

    var body: some View {
        ZStack {
            HiderMapView()
                .ignoresSafeArea()

            switch hider.currentScreen {
            case .hider:
                HiderView(hider: hider)
                    .frame(width: 300, height: 300)
                    .padding(.top, 300)
            case .mission:
                MissionView(hider: hider)
                    .frame(width: 300, height: 300)
                    .padding(.top, 300)
            case .walk(let mission):
                WalkView(mission: mission, missionVM: hider.missionVM)
                    .frame(width: 300, height: 300)
                    .padding(.top, 300)
            case .decibel(let mission):
                DecibelsView(mission: mission, missionVM: hider.missionVM)
                    .frame(width: 300, height: 300)
                    .padding(.top, 300)

            }
        }
    }
}
