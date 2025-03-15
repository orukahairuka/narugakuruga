//
//  MissionModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/15.
//

import SwiftUI

struct Mission: Identifiable, Codable {
    var id: String
    var type: String // "walk", "photo", etc.
    var description: String
    var goal: Int
    var completed: Bool = false
}
