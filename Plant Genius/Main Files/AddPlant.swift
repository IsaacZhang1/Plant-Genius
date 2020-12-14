//
//  AddPlant.swift
//  Plant Genius
//
//  Created by Isaac Zhang on 12/3/20.
//  Copyright © 2020 Isaac Zhang. All rights reserved.
//

import SwiftUI

struct AddPlant: View {
  static let DefaultPlantName = "My lovely plant"

  @State var name = ""
  @State var date_added = Date()
  let onComplete: (String, Date) -> Void

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Name")) {
          TextField("Name", text: $name)
        }
        Section {
          DatePicker(
            selection: $date_added,
            displayedComponents: .date) {
              Text("Date added").foregroundColor(Color(.gray))
          }
        }
        Section {
          
        }
      }
      .navigationBarTitle(Text("Add Plant"), displayMode: .inline)
      .navigationBarItems(trailing: Button(action: addPlantAction) {
                                        Text("Add")
                                    })
    }
  }

  private func addPlantAction() {
    onComplete(
      name.isEmpty ? AddPlant.DefaultPlantName : name,
      date_added)
  }
}
