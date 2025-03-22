import SwiftUI

struct CameraViewModel: UIViewControllerRepresentable {
    @Binding var image: UIImage
    @Binding var showingCamera: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewModel>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraViewModel>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: CameraViewModel
        
        init(parent: CameraViewModel) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            self.parent.image = image
            self.parent.showingCamera = false
        }
        
    }
}
