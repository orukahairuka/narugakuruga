//
//  narugakurugaApp.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/13.
//

import SwiftUI
import Firebase

@main
struct narugakurugaApp: App {

    //firebase初期化
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
