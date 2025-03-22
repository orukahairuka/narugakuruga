//
//  Lottie_Animation_loop.swift
//  narugakuruga
//
//  Created by kudo453602 on 2025/03/22.
//

import SwiftUI
import Lottie

struct Loop_Lottie_View: UIViewRepresentable {
    var name: String
    var animationView = LottieAnimationView()
    func makeUIView(context: UIViewRepresentableContext<Loop_Lottie_View>) -> UIView {
        let view = UIView(frame: .zero)
        // 表示したいアニメーションのファイル名
        animationView.animation = LottieAnimation.named(name)
        // 比率
        animationView.contentMode = .scaleAspectFit
//         ループモード
                animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Loop_Lottie_View>) {
    }
}
