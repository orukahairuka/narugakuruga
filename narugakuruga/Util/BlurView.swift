//
//  BlurView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/20.
//

import SwiftUI

// グラスモーフィズムのエフェクトを実現するためのBlurView
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
