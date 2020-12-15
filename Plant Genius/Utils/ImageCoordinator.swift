import SwiftUI



struct CaptureImageView {
    @Binding var isShown: Bool
    var mediaType: MediaType
    var callback : ((Image)->(Void))?
  
    func makeCoordinator() -> ImageCoordinator {
        return ImageCoordinator(isShown: $isShown, callback: callback)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if mediaType == .Camera {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                              context: UIViewControllerRepresentableContext<CaptureImageView>) {

    }
}


extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}


class ImageCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var isCoordinatorShown: Bool
    var imageInCoordinator: Image?
    var callback: ((Image)->(Void))?
    
    init(isShown: Binding<Bool>, callback: ((Image)->(Void))?) {
        _isCoordinatorShown = isShown
        self.imageInCoordinator = nil
        self.callback = callback
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageInCoordinator = Image(uiImage: unwrapImage)
        if let image = imageInCoordinator {
            if let callback = callback {
                callback(image)
            }
        }
        isCoordinatorShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
    
}
