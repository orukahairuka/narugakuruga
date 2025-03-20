import SwiftUI
import MapKit

struct LocationView: View {
    @StateObject private var locationManager = LocationViewModel()  // LocationViewModel のインスタンス
    @StateObject private var locationFetcher = GetLocationViewModel()  // GetLocationViewModel のインスタンス
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.01161, longitude: 135.76811),
        latitudinalMeters: 750,
        longitudinalMeters: 750
    )
    
    var body: some View {
        ZStack {
            // 地図を表示
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: locationFetcher.places  // 取得した場所をピンとして表示
            ) { place in
                MapPin(coordinate: place.location, tint: Color.blue)  // ピンの色を青に設定
            }
        }
        .onAppear {
            // ビューが表示されたときに位置情報を取得
            locationFetcher.fetchLocations()
            locationManager.requestPermission() //これも必要やった
            locationManager.startTracking() //これを追加しないと位置情報のやつが始まらない
        }
        .onReceive(locationFetcher.$places) { newPlaces in
            // 位置情報が更新されたときに最初の位置にマップの中心を合わせる
            if let firstPlace = newPlaces.first {
                region.center = firstPlace.location
            }
        }
    }
}
