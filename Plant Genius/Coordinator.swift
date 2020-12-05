import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: Image?
    @ObservedObject var listOfPlantImages: PlantImages
    var plant: Plant
    
    init(isShown: Binding<Bool>, image: Binding<Image?>, listOfPlantImages: PlantImages, plant: Plant) {
        print("iz: inside Coordinator init with isShown of \(isShown)")
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
        self.plant = plant
        self.listOfPlantImages = listOfPlantImages
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("iz: inside imagePickerController")

        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageInCoordinator = Image(uiImage: unwrapImage)
        if let image = imageInCoordinator {
            let day = String(listOfPlantImages.images.count)
            listOfPlantImages.images.append(PlantImage(name: "Day " + day, image: image))
        }
        isCoordinatorShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
    
}
