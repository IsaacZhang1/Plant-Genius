import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: Image?
    var callback: ((Image)->(Void))?
    
    init(isShown: Binding<Bool>, image: Binding<Image?>, callback: ((Image)->(Void))?) {
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
        self.callback = callback
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageInCoordinator = Image(uiImage: unwrapImage)
        if let image = imageInCoordinator {
//            let day = String(listOfPlantImages.images.count)
//            listOfPlantImages.images.append(PlantImage(name: "Day " + day, image: image))
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
