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
    private var caughtListener: ListenerRegistration? //鬼に捕まったかどうかを個人に通知
    private var allCaughtListener: ListenerRegistration? //誰かが鬼に捕まったら全体に通知を監視


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

    // 全プレイヤーの監視
        func startListeningAllCapturedPlayers(onAnyPlayerCaught: @escaping (String) -> Void) {
            stopListeningAllCapturedPlayers()
            allCaughtListener = db.collection("caughtPlayers")
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        print("Firestore監視エラー:", error.localizedDescription)
                        return
                    }

                    guard let snapshot = snapshot else { return }

                    for document in snapshot.documents {
                        let data = document.data()
                        if let caught = data["caught"] as? Bool, caught {
                            let playerUUID = document.documentID
                            print("📢 誰かが捕まった！UUID:", playerUUID)
                            DispatchQueue.main.async {
                                onAnyPlayerCaught(playerUUID)
                            }
                        }
                    }
                }
        }


    //個人の監視を停止する
    func stopListeningCaptured() {
        if let listener = caughtListener {
            print("Firestoreのリスナーを解除")
            listener.remove()
        }
        caughtListener = nil
    }

    //全体の監視を停止する
    func stopListeningAllCapturedPlayers() {
            allCaughtListener?.remove()
            allCaughtListener = nil
        }

}
