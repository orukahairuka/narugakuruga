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
        resetMissions() // 🔄 アプリ起動時にミッションをリセット
        fetchMission()
    }
    
    //順番にミッションを取得
    func fetchMission() {
        guard completedMissionsCount < 4 else {
            print("⚠️ すでに4つのミッションをクリアしました。新しいお題は取得しません。")
            return
        }
        
        print("🔍 Firestore からミッションを取得中...")
        
        db.collection("missions")
            .whereField("completed", isEqualTo: false) // ✅ 未完了のミッションのみ取得
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Firestore クエリエラー: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("⚠️ Firestore からのレスポンスが `nil` です。")
                    return
                }
                
                let documents = snapshot.documents.sorted { $0.documentID < $1.documentID } // ✅ Firestore の ID 順にソート
                print("📄 Firestore から \(documents.count) 件のドキュメントを取得しました。")
                
                if documents.isEmpty {
                    print("⚠️ ミッションが Firestore に1つもありません！")
                    return
                }
                
                // 一番最初のミッションを取得
                if let doc = documents.first {
                    let data = doc.data()
                    print("✅ 取得したミッション: \(data)")
                    
                    DispatchQueue.main.async {
                        self.currentMission = Mission(
                            id: doc.documentID, // ✅ Firestore の自動生成 ID を id として使用
                            type: data["type"] as? String ?? "",
                            description: data["description"] as? String ?? "",
                            goal: data["goal"] as? Int ?? 0,
                            completed: data["completed"] as? Bool ?? false
                        )
                    }
                } else {
                    print("⚠️ Firestore にドキュメントはあるが、最初のミッションが取得できませんでした。")
                }
            }
    }
    
    
    
    
    
    //ミッションを完了
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
                            self.fetchMission()
                        }
                    }
                }
            }
        }
    }

    //アプリ起動時にミッションをリセット
    func resetMissions() {
        print("🔄 ミッションをリセット中...")

        db.collection("missions").getDocuments { snapshot, error in
            if let error = error {
                print("❌ ミッションリセットエラー: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("⚠️ ミッションリセット時に Firestore のレスポンスが `nil` です。")
                return
            }

            for doc in documents {
                db.collection("missions").document(doc.documentID).updateData(["completed": false]) { error in
                    if let err = err {
                        print("❌ ミッション \(doc.documentID) のリセット失敗: \(err.localizedDescription)")
                    } else {
                        print("✅ ミッション \(doc.documentID) をリセットしました")
                    }
                }
            }
        }
    }


}

