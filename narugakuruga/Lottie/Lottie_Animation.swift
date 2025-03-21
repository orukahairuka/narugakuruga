//
//  Lottie_Demo.swift
//  narugakuruga
//
//  Created by kudo453602 on 2025/03/19.
//

// Lottie_View(name: String)のStringをいじれば(例: "Party")好きなアニメーションを呼び出せる。

import SwiftUI
import Lottie

struct Lottie_View: UIViewRepresentable {
    var name: String
    var animationView = LottieAnimationView()
    func makeUIView(context: UIViewRepresentableContext<Lottie_View>) -> UIView {
        let view = UIView(frame: .zero)
        // 表示したいアニメーションのファイル名
        animationView.animation = LottieAnimation.named(name)
        // 比率
        animationView.contentMode = .scaleAspectFit
        // ループモード
//        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Lottie_View>) {
    }
}

//struct DemoView: View {
//    var body: some View {
//        Lottie_DemoView(name: "Animation - 1728279190927.json")
//    }
//}
//#Preview {
//    Lottie_DemoView()
//}
