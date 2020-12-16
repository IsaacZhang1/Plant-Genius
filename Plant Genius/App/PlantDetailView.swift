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

enum MediaType {
    case Picker
    case Camera
}

class PlantImages: ObservableObject {
    @Published var images: [PlantImage] = [PlantImage]();
    
    init(images: [PlantImage]) {
        self.images = images
    }
    
}

struct PlantDetailView: View {
    var plant: Plant
    @State var image: Image? = nil
    @State var showCaptureImageView: Bool = false
    @State var mediaType: MediaType
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
                HStack(spacing: 50) {
                    Button(action: {
                        mediaType = .Camera
                        self.showCaptureImageView.toggle()
                    }) {
                        Image(systemName: "camera").resizable()
                            .frame(width: CGFloat(30), height: CGFloat(25))
                    }
                    Button(action: {
                        mediaType = .Picker
                        self.showCaptureImageView.toggle()
                    }) {
                        Image(systemName: "photo").resizable()
                            .frame(width: CGFloat(30), height: CGFloat(25))
                    }
                }.padding(.bottom, 20)
              }
              if (showCaptureImageView) {
                CaptureImageView(isShown: $showCaptureImageView, mediaType: mediaType) { returnedImage in
                    let day = String(listOfPlantImages.images.count)
                    listOfPlantImages.images.append(PlantImage(name: "Day " + day, image: returnedImage))
                }
              }
            }
        }.navigationBarTitle(Text(plant.name!))
   }
}


