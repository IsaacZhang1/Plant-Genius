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

  var body: some View {
    VStack(alignment: .leading) {
        NavigationLink(destination: PlantDetailView(plant: plant, mediaType: .Camera)) {
            plant.name.map(Text.init)
                .font(.headline)
        }
    }
  }
}
