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
        NavigationLink(destination: PlantDetailView(plant: plant, mediaType: .Camera)) {
            HStack(spacing: 25) {
                coverImage?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                plant.name.map(Text.init)
                    .font(.headline)
                
            }
            .onAppear() {
                Print("iz: the coverImage is \(coverImage)")
                if let name = plant.name, coverImage == nil {
                    loadImageFromDiskWith(fileName: name, callback: setImage)
                }
            }
        }

    }
    
    func setImage(image: Image?) {
        if let unwrappedImage = image {
            self.coverImage = unwrappedImage
        }
    }
    
    
}
