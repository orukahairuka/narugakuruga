//
//  GameWinView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/19.
//

import SwiftUI

struct GameWinView: View {
    var body: some View {
        VStack {
            Text("🎉 ゲームクリア！ 🎉")
                .font(.largeTitle)
                .foregroundColor(.green)
                .padding()

            Text("おめでとうございます！4つのミッションを達成しました！")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()

            Button("タイトルへ戻る") {
                // ここにタイトル画面へ遷移する処理を書く
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }
}
