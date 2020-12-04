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
        NavigationLink(destination: PlantDetailView(plant: plant)) {
            plant.name.map(Text.init)
              .font(.caption)
            HStack {
              plant.date_added.map { Text(Self.releaseFormatter.string(from: $0)) }
                .font(.caption)
            }
        }
    }
  }
}
