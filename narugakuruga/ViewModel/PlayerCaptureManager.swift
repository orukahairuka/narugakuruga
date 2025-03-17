//
//  PlayerCaptureViewModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/17.
//

import FirebaseFirestore

//プレイヤーが捕まったかどうかを管理するクラス
class PlayerCaptureManager {
    private let db = Firestore.firestore()

    // 捕まえたプレイヤーをFirestoreに記録（鬼側が呼ぶ）
    func recordCapturedPlayer(playerID: UUID, completion: ((Error?) -> Void)? = nil) {
        print("捕まえたプレイヤーをfirestoreに記録")
        let data: [String: Any] = [
            "id": playerID.uuidString,
            "timestamp": Timestamp(date: Date())
        ]
        db.collection("caughtPlayers").document(playerID.uuidString).setData(data, completion: completion)
    }

    // 自分が捕まったかどうかを監視（隠れる側が呼ぶ）
    func listenIfCaught(playerID: UUID, caughtHandler: @escaping () -> Void) -> ListenerRegistration {
        print("プレイヤーは自分が捕まったかどうかを監視")
        return db.collection("caughtPlayers").document(playerID.uuidString)
            .addSnapshotListener { snapshot, error in
                if let snapshot = snapshot, snapshot.exists {
                    caughtHandler()
                }
            }
    }
}
