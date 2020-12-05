//
//  PlantDetailView.swift
//  Plant Genius
//
//  Created by Isaac Zhang on 11/21/20.
//  Copyright © 2020 Isaac Zhang. All rights reserved.
//

import SwiftUI

struct PlantImage: Identifiable {
    let id = UUID()
    var name: String
    var image: Image
}

class PlantImages: ObservableObject {
    @Published var images: [PlantImage] = [PlantImage]();
    
    init(images: [PlantImage]) {
        self.images = images
    }
    
    func printImages() {
        print("the images are: \(images)")
    }
}

struct PlantDetailView: View {
    var plant: Plant
    @State var image: Image? = nil
    @State var showCaptureImageView: Bool = false
    @ObservedObject var listOfPlantImages: PlantImages = PlantImages(images: [])

    var body: some View {
        NavigationView {
            ZStack {
              VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(listOfPlantImages.images) { post in
                            Text(post.name)
                            post.image.resizable()
                                    .frame(width: CGFloat(250), height: CGFloat(250))
                                  .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: CGFloat(4)))
                                    .shadow(radius: CGFloat(10))
                            self.Print("inside of For Each - listOfPlantImages is: \(self.listOfPlantImages)" )
                        }
                        Print("inside of the ScrollView - listOfPlantImages is: \(listOfPlantImages)")
                        Spacer()
                    }
                }
                Button(action: {
                  self.showCaptureImageView.toggle()
                }) {
                  Text("Take picture")
                }
              }
              if (showCaptureImageView) {
                Print("iz: before CaptureImageView with showCaptureImageView of \(showCaptureImageView)")
                CaptureImageView(isShown: $showCaptureImageView, image: $image, listOfPlantImages: listOfPlantImages, plant: plant)
              }
            }
        }.navigationBarTitle(Text(plant.name!))
   }
}


struct CaptureImageView {
    @Binding var isShown: Bool
    @Binding var image: Image?
    @ObservedObject var listOfPlantImages: PlantImages
    var plant: Plant
  
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image, listOfPlantImages: listOfPlantImages, plant: plant)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
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
