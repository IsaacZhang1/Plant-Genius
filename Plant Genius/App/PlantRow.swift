//
//  PlantRow.swift
//  Plant Genius
//
//  Created by Isaac Zhang on 12/3/20.
//  Copyright © 2020 Isaac Zhang. All rights reserved.
//

import SwiftUI

struct PlantRow: View {
    let plant: Plant
    static let releaseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    @State var coverImage: Image?
    

    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: PlantDetailView(plant: plant, mediaType: .Camera)) {
                HStack {
                    Text("Hello World")
                    plant.name.map(Text.init)
                        .font(.headline)
                    coverImage?
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height:75, alignment: .center)
                }
            }
        }.onAppear() {
            if let name = plant.name {
                loadImageFromDiskWith(fileName: name, callback: setImage)
            }
        }
    }
    
    func setImage(image: Image?) {
        if let unwrappedImage = image {
            self.coverImage = unwrappedImage
        }
    }
    
    
}
