//
//  PrimaryButtonStyle.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/19.
//

import SwiftUI

struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

extension View {
    func buttonStyle(_ style: PrimaryButtonStyle) -> some View {
        self.modifier(style)
    }
}
