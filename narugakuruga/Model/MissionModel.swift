//
//  MissionModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/15.
//

import SwiftUI

struct Mission: Identifiable, Codable {
    var id: String //FirestoreのドキュメントID
    var type: String // "walk", "photo", etc.
    var description: String //Missonの説明
    var goal: Int  //写真を撮る枚数や歩数の目標値
    var completed: Bool = false //Missionが完了したかどうか
}
