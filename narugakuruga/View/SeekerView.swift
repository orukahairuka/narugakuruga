//
//  SeekerView.swift
//  narugakuruga
//
//  Created by 櫻井絵理香 on 2025/03/17.
//

import SwiftUI
import MapKit

struct SeekerView: View {
    @ObservedObject var seeker: SeekerViewModel

    @StateObject private var locationManager = LocationViewModel()
    @StateObject private var locationFetcher = GetLocationViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        latitudinalMeters: 750,
        longitudinalMeters: 750
    )

    var peripherals: [(uuid: UUID, rssi: Int)] {
        seeker.discoveredPeripherals
            .map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1 }
    }

    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack(spacing: 20) {
                    Map(
                        coordinateRegion: $region,
                        interactionModes: .all,
                        showsUserLocation: true,
                        annotationItems: locationFetcher.places
                    ) { place in
                        MapPin(coordinate: place.location, tint: Color.blue)
                    }
                    .onAppear {
                        locationFetcher.fetchLocations()
                        locationManager.requestPermission()
                        locationManager.startTracking()
                    }
                    .onReceive(locationFetcher.$places) { newPlaces in
                        if let firstPlace = newPlaces.first {
                            region.center = firstPlace.location
                        }
                    }
                    .padding()
                    .frame(height: 400)
                    .navigationBarBackButtonHidden(true)

                    if seeker.isSeeking {
                        StatusTextView(text: "近くにいるプレイヤー")
                            .padding(.top)

                        VStack(spacing: 10) {
                            ForEach(Array(peripherals.enumerated()), id: \.element.uuid) { _, item in
                                let playerName = seeker.playerNameMapping[item.uuid] ?? "Unknown"

                                PlayerInfoView(
                                    uuid: item.uuid,
                                    rssi: item.rssi,
                                    seeker: seeker,
                                    playerName: playerName
                                )
                                .onAppear {
                                    if playerName == "Unknown" {
                                        seeker.updatePlayerName(for: item.uuid)
                                    }
                                }
                            }
                        }
                    }
                }
                FetchImageView()
                            .padding(.bottom)
            }
        }
    }
}

struct PlayerInfoView: View {
    let uuid: UUID
    let rssi: Int
    @ObservedObject var seeker: SeekerViewModel
    let playerName: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("名前: \(playerName)")
                Text("UUID: \(uuid.uuidString)")
                Text("RSSI: \(rssi)")
            }
            .foregroundColor(.black)

            Spacer()

            CaptureButtonView(uuid: uuid, seeker: seeker, playerName: playerName)
        }
        .padding()
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct CaptureButtonView: View {
    let uuid: UUID
    @ObservedObject var seeker: SeekerViewModel
    let playerName: String

    var body: some View {
        Button("捕まえた！") {
            let captureManager = PlayerCaptureManager()
            if let shortPlayerUUID = seeker.playerUUIDMapping[uuid] {
                print("🔥【鬼側】捕まえたプレイヤーの短縮UUIDは:", shortPlayerUUID)
                print("🎯 捕まえたプレイヤー名: \(playerName)")

                captureManager.recordCapturedPlayer(playerShortUUID: shortPlayerUUID, playerName: playerName) { error in
                    if let error = error {
                        print("Firestore書き込みエラー:", error.localizedDescription)
                    } else {
                        print("Firestoreに書き込みました！（\(shortPlayerUUID)）")
                    }
                }
            } else {
                print("⚠️プレイヤーの短縮UUIDが見つかりませんでした。")
            }
        }
        .padding()
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}
