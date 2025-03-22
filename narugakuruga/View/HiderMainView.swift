//
//  b.swift
//  narugakuruga
//
//  Created by 森田将嵩 on 2025/03/22.
//

import SwiftUI

struct HiderMainView: View {
    @StateObject var hider: HiderViewModel
    var body: some View {
        VStack {
            HiderView(hider: hider)
            HiderMapView()
        }
    }
}
