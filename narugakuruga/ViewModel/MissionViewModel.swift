//
//  MissionViewModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/15.
//

import SwiftUI
import FirebaseFirestoreInternal


class MissionViewModel: ObservableObject {
    private let db = Firestore.firestore()
    @Published var currentMission: Mission?

    init() {
        fetchRandomMission()
    }

    // Firestoreからランダムなお題を取得
    func fetchRandomMission() {
        db.collection("missions").getDocuments { snapshot, error in
            if let documents = snapshot?.documents, let doc = documents.randomElement() {
                let data = doc.data()
                DispatchQueue.main.async {
                    self.currentMission = Mission(
                        id: doc.documentID,
                        type: data["type"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        goal: data["goal"] as? Int ?? 0
                    )
                }
            }
        }
    }

    // お題を達成したらFirestoreを更新
    func completeMission() {
        guard let mission = currentMission else { return }
        db.collection("missions").document(mission.id).updateData(["completed": true])
        print("お題クリア！🎉")
    }
}
