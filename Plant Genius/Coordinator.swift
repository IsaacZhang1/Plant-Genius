import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: Image?
    @Binding var listOfPlantImages: [PlantImage]
    
    init(isShown: Binding<Bool>, image: Binding<Image?>, listOfPlantImages: Binding<[PlantImage]>) {
        print("iz: inside Coordinator init")
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
        _listOfPlantImages = listOfPlantImages
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("iz: inside imagePickerController")

        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageInCoordinator = Image(uiImage: unwrapImage)
        if let image = imageInCoordinator {
            listOfPlantImages.append(PlantImage(image: image))
        }
        isCoordinatorShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
}
