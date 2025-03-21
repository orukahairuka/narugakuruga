import Foundation
import FirebaseFirestore
import CoreLocation

class GetLocationViewModel: ObservableObject {
    
    private let db = Firestore.firestore()  // Firestoreインスタンス
    
    @Published var places: [IdentifiablePlace] = []  // 取得した場所のリスト
    
    // Firestore から位置情報をリアルタイムで取得するメソッド
    func fetchLocations() {
        // リアルタイムでデータの変更を監視する
        db.collection("location")
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                    return
                }
                print("Documents fetched successfully.")
                // Firestore のデータから場所の情報を取得
                self.places = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    if let latitude = data["latitude"] as? Double,
                       let longitude = data["longitude"] as? Double {
                        print(IdentifiablePlace(id: UUID(), lat: latitude, long: longitude))
                        return IdentifiablePlace(id: UUID(), lat: latitude, long: longitude)
                    }
                    return nil
                } ?? []
            }
    }
}
