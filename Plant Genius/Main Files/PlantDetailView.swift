//
//  PlantDetailView.swift
//  Plant Genius
//
//  Created by Isaac Zhang on 11/21/20.
//  Copyright © 2020 Isaac Zhang. All rights reserved.
//

import SwiftUI

//struct ImageModel: Identifiable {
//    let id: Int
//    let imageView: String
//}
//
//struct ImageView: View {
//    let postImages: ImageModel
//    var body: some View {
//        Image(postImages.imageView)
//            .resizable()
//            .frame(width: 100, height: 100)
//            .clipShape(Circle())
//    }
//}

struct PlantImage {
    let id = UUID()
    var image: Image
}

struct PlantDetailView: View {
    var plant: Plant
    @State var image: Image? = nil
    @State var showCaptureImageView: Bool = false
//    @State var plantImages = PlantImages(id: 0, images: [])
    @State var listOfPlantImages: [PlantImage] = [PlantImage]()

    var body: some View {
        NavigationView {
            ZStack {
              VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(listOfPlantImages, id: \.id) { post in
                            ForEach(0..<3) { _ in
    //                            ImageView(postImages: post)
                            }
                        }
                    }
                    Spacer()
                }
                Button(action: {
                  self.showCaptureImageView.toggle()
                }) {
                  Text("Take picture")
                }
    //            image?.resizable()
    //                .frame(width: CGFloat(250), height: CGFloat(200))
    //              .clipShape(Circle())
    //                .overlay(Circle().stroke(Color.white, lineWidth: CGFloat(4)))
    //                .shadow(radius: CGFloat(10))
              }
              if (showCaptureImageView) {
                Print("iz: before CaptureImageView")
                CaptureImageView(isShown: $showCaptureImageView, image: $image, listOfPlantImages: $listOfPlantImages)
              }
            }
        }
        
   }
}


struct CaptureImageView {
    @Binding var isShown: Bool
      @Binding var image: Image?
      @Binding var listOfPlantImages: [PlantImage]
  
    func makeCoordinator() -> Coordinator {
        Print("iz: inside makeCoordinator")
        return Coordinator(isShown: $isShown, image: $image, listOfPlantImages: $listOfPlantImages)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        Print("iz: inside makeUIViewController")
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
