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
                    .padding()
                    .padding(.top, 300)

            case .mission:
                MissionView(hider: hider)
                    .frame(width: 300, height: 300)
                    .padding()
                    .padding(.top, 300)
                    .padding(.bottom, 100)


            case .walk(let mission):
                if let missionVM = hider.missionVM {
                    WalkView(mission: mission, missionVM: missionVM)
                        .frame(width: 300, height: 300)
                        .padding()
                        .padding(.top, 300)
                        .padding(.bottom, 100)
                } else {
                    Text("ミッションの読み込み中…")
                }



            case .decibel(let mission):
                if let missionVM = hider.missionVM {
                    DecibelsView(mission: mission, missionVM: missionVM)
                        .frame(width: 300, height: 300)
                        .padding()
                        .padding(.top, 300)
                        .padding(.bottom, 100)
                } else {
                    Text("ミッションデータ読み込み中…")
                        .frame(width: 300, height: 300)
                        .padding()
                        .padding(.top, 300)
                        .padding(.bottom, 100)
                }



            case .result:
                GameWinView()
                    .frame(width: 300, height: 300)
                    .padding()
                    .padding(.top, 300)
                    .padding(.bottom, 100)

            }
        }
    }
}
