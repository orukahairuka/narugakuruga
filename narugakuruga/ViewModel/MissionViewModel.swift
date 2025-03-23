//
//  MissionViewModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/15.
//

import SwiftUI
import FirebaseFirestore

class MissionViewModel: ObservableObject {
    @ObservedObject var hider: HiderViewModel
    private let db = Firestore.firestore()
    @Published var currentMission: Mission?
    @Published var completedMissionsCount = 0
    @Published var gameWon = false
    
    init(hider: HiderViewModel) {
        self.hider = hider
        resetMissions()
        fetchMission()
    }

    // ランダムにミッションを取得
    func fetchMission() {
        guard completedMissionsCount < 4 else {
            print("⚠️ すでに4つのミッションをクリアしました。新しいお題は取得しません。")
            return
        }
        
        print("🔍 Firestore からミッションを取得中...")
        
        db.collection("missions")
            .whereField("completed", isEqualTo: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Firestore クエリエラー: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("⚠️ Firestore からのレスポンスが `nil` です。")
                    return
                }
                
                print("📄 Firestore から \(documents.count) 件のドキュメントを取得しました。")
                
                if documents.isEmpty {
                    print("⚠️ ミッションが Firestore に1つもありません！")
                    return
                }
                
                // ランダムにミッションを選択
                let randomIndex = Int.random(in: 0..<documents.count)
                let randomDocument = documents[randomIndex]
                let data = randomDocument.data()
                print("🎲 ランダムに選ばれたミッション: \(data)")
                
                DispatchQueue.main.async {
                    self.currentMission = Mission(
                        id: randomDocument.documentID,
                        type: data["type"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        goal: data["goal"] as? Int ?? 0,
                        completed: data["completed"] as? Bool ?? false
                    )
                }
            }
    }

    // ミッションを完了
    func completeMission() {
        guard let mission = currentMission else { return }

        db.collection("missions").document(mission.id).updateData(["completed": true]) { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.completedMissionsCount += 1
                    print("お題クリア！🎉 (\(self.completedMissionsCount)/4)")

                    if self.completedMissionsCount >= 4 {
                        self.gameWon = true
                        self.hider.currentScreen = .result
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.fetchMission()
                            self.hider.currentScreen = .mission
                        }
                    }
                }
            }
        }
    }

    // アプリ起動時にミッションをリセット
    func resetMissions() {
        print("🔄 ミッションをリセット中...")

        self.db.collection("missions").getDocuments { snapshot, error in
            if let error = error {
                print("❌ ミッションリセットエラー: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("⚠️ ミッションリセット時に Firestore のレスポンスが `nil` です。")
                return
            }

            for doc in documents {
                self.db.collection("missions").document(doc.documentID).updateData(["completed": false]) { error in
                    if let error = error {
                        print("❌ ミッション \(doc.documentID) のリセット失敗: \(error.localizedDescription)")
                    } else {
                        print("✅ ミッション \(doc.documentID) をリセットしました")
                    }
                }
            }
        }
    }
}
