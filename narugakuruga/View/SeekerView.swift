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
    
    @StateObject private var locationManager = LocationViewModel()  // LocationViewModel のインスタンス
    @StateObject private var locationFetcher = GetLocationViewModel()  // GetLocationViewModel のインスタンス
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
            VStack(spacing: 20) {
                Text("鬼の画面(わかるようにするLottieとか画像とか)")
                Map(coordinateRegion: $region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    annotationItems: locationFetcher.places  // 取得した場所をピンとして表示
                ) { place in
                    MapPin(coordinate: place.location, tint: Color.blue)  // ピンの色を青に設定
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

                if seeker.isSeeking {
                    StatusTextView(text: "近くにいるプレイヤー")
                        .padding(.top)

                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(Array(peripherals.enumerated()), id: \.element.uuid) { _, item in
                                PlayerInfoView(uuid: item.uuid, rssi: item.rssi, seeker: seeker)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct PlayerInfoView: View {
    let uuid: UUID
    let rssi: Int
    @ObservedObject var seeker: SeekerViewModel

    var body: some View {
        HStack {
            Text("UUID: \(uuid.uuidString), RSSI: \(rssi)")
                .foregroundColor(.black)
            Spacer()
            CaptureButtonView(uuid: uuid, seeker: seeker)
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

    var body: some View {
        Button("捕まえた！") {
            let captureManager = PlayerCaptureManager()
            if let shortPlayerUUID = seeker.playerUUIDMapping[uuid] {
                print("🔥【鬼側】捕まえたプレイヤーの短縮UUIDは:", shortPlayerUUID)
                captureManager.recordCapturedPlayer(playerShortUUID: shortPlayerUUID) { error in
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
