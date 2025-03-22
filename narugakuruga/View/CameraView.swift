import SwiftUI

struct CameraView: View {
    @State var image = UIImage()
    @State var showingCamera: Bool = false
    
    var body: some View {
        VStack {
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
                CameraViewModel(image: $image, showingCamera: $showingCamera)
            })
        }
    }
}

#Preview {
    ContentView()
}
