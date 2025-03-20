import Foundation
import CoreLocation
import MapKit
import FirebaseFirestore

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let collectionName = "location"
    
    @Published var lastLocation: CLLocationCoordinate2D?
    @Published var places: [IdentifiablePlace] = []
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        startTracking()
    }
    
    /// 位置情報の取得許可をリクエスト
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    ///　ここで位置情報を更新する
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.lastLocation = location.coordinate
        }
    }
    
    /// Firestore に現在の位置情報を追加
    func addDatabase() {
        guard let location = lastLocation else { return }
        
        let locationData: [String: Any] = [
            "latitude": location.latitude,
            "longitude": location.longitude
        ]
        
        db.collection(collectionName).document("location").setData(locationData) { error in
            if let error = error {
                print("Firestore Write Error: \(error.localizedDescription)")
            } else {
                print("Location updated in Firestore successfully!")
            }
        }
    }
    /// 一定時間ごとに Firestore に現在の位置を送信する
    func startTracking() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            DispatchQueue.main.async {
                self.addDatabase() // Firestore に現在の位置を追加
            }
        }
    }
    
    deinit {
        listener?.remove() // Firestore のリスナーを解除
    }
}
