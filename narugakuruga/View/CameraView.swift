import SwiftUI

struct CameraView: View {
    let mission: Mission
    @State var image = UIImage()
    @State var showingCamera: Bool = false
    @ObservedObject var missionVM: MissionViewModel
    @State var cameraShooting: Bool = false
    @State private var showCountdown = false
    @State private var countdown = 60


    var body: some View {
        VStack {

            if cameraShooting {
                Text("画像をアップロードしました")
                MissionCompleteView(
                    countdown: $countdown,
                    showCountdown: $showCountdown,
                    onComplete: {
                        missionVM.completeMission()
                    }
                )
            }
            Image(uiImage: self.image)
                .resizable()
                .frame(width: 300, height: 300)
            
            Button(action: {
                // ボタンが押されたら、showingCameraがtrueになる
                showingCamera = true
            }, label: {
                Text("カメラを起動する")
            })
            // showingCameraがtrueの時に、sheetが表示される
            .sheet(isPresented: $showingCamera, content: {
                CameraViewModel(image: $image, showingCamera: $showingCamera, cameraShooting: $cameraShooting)
            })
        }
    }
}


