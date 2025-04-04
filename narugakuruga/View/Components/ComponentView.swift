//
//  ComponentView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/20.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "#C6E7FF"), Color(hex: "#A8E6CF")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct LogoView: View {
    var body: some View {
        Text("かくれんぼアプリ")
            .font(.largeTitle)
            .foregroundColor(.white)
            .shadow(radius: 5)
    }
}

struct StatusTextView: View {
    let text: String
    var color: Color = .black

    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(color)
            .padding()
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}


#Preview ("BackgroundView") {
    BackgroundView()
}

#Preview ("LogoView") {
    LogoView()
}

#Preview ("StatusTextView") {
    StatusTextView(text: "鬼になりました")
}

#Preview ("RoleButtonView") {
    RoleButtonView(title: "鬼になる", color: .red)
}

#Preview("StatusTextView") {
    StatusTextView(text: "近くにいるプレイヤー")
}
