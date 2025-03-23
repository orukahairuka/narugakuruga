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
        VStack(spacing: 20) {
            Text("📷 カメラミッション")
                .font(.title2)
                .bold()

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
            }

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .background(Color.gray.opacity(0.2))
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white) // ← 背景色で視認性UP
        .sheet(isPresented: $showingCamera) {
            CameraViewModel(
                image: $image,
                showingCamera: $showingCamera,
                cameraShooting: $cameraShooting
            )
        }
    }
}
