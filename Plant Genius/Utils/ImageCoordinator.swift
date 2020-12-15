import SwiftUI

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
