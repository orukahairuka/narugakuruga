import SwiftUI

struct HiderMainView: View {
    @StateObject var hider: HiderViewModel

    var body: some View {
        ZStack {
            // 背景として HiderMapView を全画面に設定
            HiderMapView()
                .ignoresSafeArea()

            GeometryReader { geometry in
                VStack {
                    switch hider.currentScreen {
                    case .hider:
                        HiderView(hider: hider)
                            .frame(width: geometry.size.width, height: 450)
                            .position(x: geometry.size.width / 2, y: geometry.size.height - 200)

                    case .mission:
                        MissionView(hider: hider)
                            .frame(width: geometry.size.width, height: 450)
                            .position(x: geometry.size.width / 2, y: geometry.size.height - 200)

                    case .walk(let mission):
                        if let missionVM = hider.missionVM {
                            WalkView(mission: mission, missionVM: missionVM)
                                .frame(width: geometry.size.width, height: 450)
                                .position(x: geometry.size.width / 2, y: geometry.size.height - 200)
                        } else {
                            Text("ミッションの読み込み中…")
                                .frame(width: geometry.size.width, height: 450)
                                .position(x: geometry.size.width / 2, y: geometry.size.height - 200)
                        }

                    case .decibel(let mission):
                        if let missionVM = hider.missionVM {
                            DecibelsView(mission: mission, missionVM: missionVM)
                                .frame(width: geometry.size.width, height: 450)
                                .position(x: geometry.size.width / 2, y: geometry.size.height - 200)
                        } else {
                            Text("ミッションデータ読み込み中…")
                                .frame(width: geometry.size.width, height: 450)
                                .position(x: geometry.size.width / 2, y: geometry.size.height - 200)
                        }

                    case .result:
                        GameWinView()
                            .frame(width: geometry.size.width, height: 450)
                            .position(x: geometry.size.width / 2, y: geometry.size.height - 200)

                    case .camera(let mission):
                        if let missionVM = hider.missionVM {
                            CameraView(mission: mission, missionVM: missionVM)
                                .background(Color.red.opacity(0.5)) // ← 見えるように
                                .frame(width: geometry.size.width, height: 450)
                                .position(x: geometry.size.width / 2, y: geometry.size.height - 200)

                        } else {
                            Text("ミッションデータ読み込み中…")
                                .frame(width: geometry.size.width, height: 450)
                                .position(x: geometry.size.width / 2, y: geometry.size.height - 200)
                        }

                    }
                }
            }
        }
    }
}
