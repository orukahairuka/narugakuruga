//
//  MissionViewModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/15.
//

import SwiftUI
import FirebaseFirestore

class MissionViewModel: ObservableObject {
    private let db = Firestore.firestore()
    @Published var currentMission: Mission?
    @Published var completedMissionsCount = 0
    @Published var gameWon = false

    init() {
        fetchRandomMission()
    }

    func fetchRandomMission() {
        guard completedMissionsCount < 4 else { return } // 4回クリアしたら新しいお題を出さない

        db.collection("missions").getDocuments { snapshot, error in
            if let documents = snapshot?.documents, let doc = documents.randomElement() {
                let data = doc.data()
                DispatchQueue.main.async {
                    self.currentMission = Mission(
                        id: doc.documentID,
                        type: data["type"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        goal: data["goal"] as? Int ?? 0,
                        completed: data["completed"] as? Bool ?? false
                    )
                }
            }
        }
    }

    func completeMission() {
        guard let mission = currentMission else { return }
        db.collection("missions").document(mission.id).updateData(["completed": true]) { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.completedMissionsCount += 1
                    print("お題クリア！🎉 (\(self.completedMissionsCount)/4)")

                    if self.completedMissionsCount >= 4 {
                        self.gameWon = true
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                            self.fetchRandomMission()
                        }
                    }
                }
            }
        }
    }
}
