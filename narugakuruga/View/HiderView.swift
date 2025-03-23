//
//  HiderView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/17.
//

import SwiftUI
import AVFoundation

struct HiderView: View {
    @ObservedObject var hider: HiderViewModel
    private let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {

                if hider.isHiding {
                    MissionCountdownView(timeRemaining: hider.timeRemaining)
                }

                if hider.caught {
                    StatusTextView(text: "あなたは捕まりました！", color: .red)
                } else {
                    StatusTextView(text: "あなたは隠れています", color: .green)
                        .padding(.bottom, 40)
                }

                if let caughtPlayer = hider.caughtPlayerName {
                    StatusTextView(text: "\(caughtPlayer) が捕まりました！", color: .red)
                        .transition(.opacity)
                        .animation(.easeInOut, value: caughtPlayer)
                        .onTapGesture {
                            speak("\(caughtPlayer) が捕まりました！")
                        }
                }
            }
        }
        .onAppear {
            hider.observeAllCaughtPlayers()
        }
    }

    private func speak(_ string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        synthesizer.speak(utterance)
    }
}
