//
//  HiderView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/17.
//

import SwiftUI

struct HiderView: View {
    @ObservedObject var hider: HiderViewModel

    var body: some View {
        VStack {
            Text("隠れる側の画面").font(.largeTitle).padding()

            if hider.isHiding {
                Text("ミッション開始まで: \(hider.timeRemaining) 秒")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding()
            }

            if hider.caught {
                Text("あなたは捕まりました！")
                    .font(.title)
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("あなたは隠れています")
                    .font(.title)
                    .foregroundColor(.green)
                    .padding()

            }

            NavigationLink(destination: MissionView(), isActive: $hider.navigateToMission) {
                EmptyView()
            }
        }
    }
}
