import SwiftUI
import MapKit

struct LocationView: View {
    
    @StateObject private var locationManager = LocationViewModel() // ViewModel を参照
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.01161, longitude: 135.76811),
        latitudinalMeters: 750,
        longitudinalMeters: 750
    )
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                interactionModes: .pan,
                showsUserLocation: true,
                annotationItems: locationManager.places
            ) { place in
                MapPin(coordinate: place.location, tint: Color.blue)
            }
        }
        .onAppear {
            locationManager.requestPermission()
            locationManager.startTracking()
        }
        .onReceive(locationManager.$lastLocation) { newLocation in
            if let newLocation = newLocation {
                // DispatchQueue.main.async を使って状態の変更をビューの描画後に実行
                DispatchQueue.main.async {
                    region = MKCoordinateRegion(
                        center: newLocation,
                        latitudinalMeters: 750,
                        longitudinalMeters: 750
                    )
                }
            }
        }
    }
}
