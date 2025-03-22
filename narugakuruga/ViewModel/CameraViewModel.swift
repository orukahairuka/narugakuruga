import SwiftUI
import Supabase
import Foundation

struct CameraViewModel: UIViewControllerRepresentable {
    @Binding var image: UIImage
    @Binding var showingCamera: Bool
    @State private var imageUrls: [String] = []  // 画像URLを格納する配列
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: CameraViewModel
        
        init(parent: CameraViewModel) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.parent.image = image
            self.parent.showingCamera = false
            
            Task {
                await self.uploadImageToSupabase(image: image)
            }
        }
        
        // 画像をSupabaseにアップロードする関数
        func uploadImageToSupabase(image: UIImage) async {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("画像データの変換に失敗しました")
                return
            }
            
            let bucketName = "image"  // Supabaseバケット名
            let fileName = "\(UUID().uuidString).jpg"  // ランダムなファイル名
            
            let client = SupabaseManager.shared.client

            do {
                // 画像をアップロード
                try await client.storage.from(bucketName).upload(path: fileName, file: imageData)
                print("画像アップロード成功")
            } catch {
                print("画像アップロードに失敗しました: \(error.localizedDescription)")
            }
        }
    }
}
