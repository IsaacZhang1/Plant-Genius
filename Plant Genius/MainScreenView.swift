//
//  ContentView.swift
//  Plant Genius
//
//  Created by Isaac Zhang on 11/19/20.
//  Copyright © 2020 Isaac Zhang. All rights reserved.
//

import SwiftUI


class UserInfo: ObservableObject {
    @Published var plantList:[String] = []
}

struct MainScreenView: View {
//    @ObservedObject var userInfo = UserInfo()
    @State var currentPlant: String = ""
    @State var plantList:[String] = []

    var body: some View {
        NavigationView {
            VStack {
                List(plantList, id: \.self) { plant in
                    NavigationLink(destination: PlantDetailView(plantName: plant)) {
                        Text(plant)
                    }
                }.navigationBarTitle("Daily Plant Logger");
                TextField("Enter the name of your plant",
                          text: $currentPlant,
                          onEditingChanged: { _ in print("changed") },
                          onCommit: {
                            if(self.currentPlant.trimmingCharacters(in: .whitespaces) != "") {
                                self.plantList.append(self.currentPlant)
                                self.currentPlant = ""
                            }
                          }
                ).padding()
            }
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}

