//
//  SpeechView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/22.
//

import SwiftUI
import AVFoundation

struct SpeechView: View {
    @State private var text = "こんにちは、これは読み上げテストです"
    private let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack(spacing: 20) {
            TextField("読み上げるテキストを入力", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("読み上げる") {
                speak(text)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }

    private func speak(_ string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP") // 日本語で読み上げ
        synthesizer.speak(utterance)
    }
}

