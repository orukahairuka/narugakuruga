//
//  PlayerCaptureViewModel.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/17.
//

import FirebaseFirestore

//プレイヤーが捕まったかどうかを管理するクラス
// 短縮UUIDをドキュメントIDに使うように調整
// PlayerCaptureManagerの修正版
class PlayerCaptureManager {
    private let db = Firestore.firestore()
    private var caughtListener: ListenerRegistration?

    // String型の短縮UUIDを使う
    func recordCapturedPlayer(playerShortUUID: String, completion: ((Error?) -> Void)? = nil) {
        print("捕まえたプレイヤーをFirestoreに記録")
        let data: [String: Any] = [
            "caught": true,
            "caughtAt": Timestamp(date: Date())
        ]
        db.collection("caughtPlayers").document(playerShortUUID).setData(data, completion: completion)
    }

    // 監視する側も同様に短縮UUIDで監視
    func startListeningCaptured(playerShortUUID: String, onCaught: @escaping () -> Void) {
        print("【Firestore監視開始】短縮UUID:", playerShortUUID)

        // ★ 既存のリスナーを削除してから新規リスナーを登録する
        stopListeningCaptured()

        caughtListener = db.collection("caughtPlayers")
            .document(playerShortUUID)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Firestore監視エラー:", error.localizedDescription)
                    return
                }

                guard let snapshot = snapshot, let data = snapshot.data(),
                      let caught = data["caught"] as? Bool, caught else {
                    print("プレイヤーはまだ捕まっていません。")
                    return
                }

                DispatchQueue.main.async {
                    print("✅ プレイヤーが捕まった！（Firestoreで確認済み）") // ここでだけログを出す
                    onCaught()
                }
            }
    }



    func stopListeningCaptured() {
        if let listener = caughtListener {
            print("Firestoreのリスナーを解除")
            listener.remove()
        }
        caughtListener = nil
    }

}
