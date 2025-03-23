import SwiftUI


struct CameraView: View {
    let mission: Mission
    @ObservedObject var missionVM: MissionViewModel

    @State private var image: UIImage = UIImage(systemName: "camera") ?? UIImage()
    @State private var showingCamera: Bool = false
    @State private var cameraShooting: Bool = false
    @State private var showCountdown: Bool = false
    @State private var countdown: Int = 60

    var body: some View {
        ZStack {
            // 背景
            BackgroundView()

            VStack(spacing: 20) {
                Text("鬼を撮影しろ！")
                    .font(.title2)
                    .bold()

                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)

                Button(action: {
                    showingCamera = true
                }) {
                    Text("カメラを起動する")
                        .font(.headline)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.9))
                    .shadow(radius: 10)
            )
            .padding()

            if cameraShooting {
                Text("✅ 画像をアップロードしました")
                    .foregroundColor(.green)

                MissionCompleteView(
                    countdown: $countdown,
                    showCountdown: $showCountdown,
                    onComplete: {
                        missionVM.completeMission()
                    }
                )
                .frame(width: 500, height: 500)
            }
        }
        .sheet(isPresented: $showingCamera) {
            CameraViewModel(
                image: $image,
                showingCamera: $showingCamera,
                cameraShooting: $cameraShooting
            )
        }
    }
}
