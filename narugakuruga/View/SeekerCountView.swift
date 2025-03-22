import SwiftUI

struct SeekerCountView: View {
    @State var count = 40
    @ObservedObject var seeker: SeekerViewModel
    @State private var isNavigatingToSeeker = false
    @State private var timer: Timer? = nil
    
    var body: some View {
        NavigationStack{
            ZStack{
                BackgroundView()
                // カウントダウン表示
                Text("\(count)秒")
                    .font(.largeTitle)
                    .padding()
                
                if !isNavigatingToSeeker {
                    NavigationLink(destination: SeekerView(seeker: seeker), isActive: $isNavigatingToSeeker) {
                        EmptyView()
                    }
                    .onAppear {
                        startCountdown()
                    }
                }
            }
        }
    }
    
    // カウントダウンを開始する関数
    func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if count > 0 {
                count -= 1
            } else {
                // 40秒経過後に遷移を開始
                isNavigatingToSeeker = true
                timer?.invalidate() // タイマーを停止
            }
        }
    }
}
