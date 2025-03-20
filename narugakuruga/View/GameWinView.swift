//
//  GameWinView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/19.
//

import SwiftUI

struct GameWinView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {
                StatusTextView(text: "🎉 ゲームクリア！ 🎉", color: .green)

                StatusTextView(text: "おめでとうございます！4つのミッションを達成しました！", color: .black)

                Button("タイトルへ戻る") {
                    // ここにタイトル画面へ遷移する処理を書く
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }
}
