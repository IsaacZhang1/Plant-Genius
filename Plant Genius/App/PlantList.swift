//
//  ContentView.swift
//  Plant Genius
//
//  Created by Isaac Zhang on 11/19/20.
//  Copyright © 2020 Isaac Zhang. All rights reserved.
//

import SwiftUI



struct PlantList: View {
    @ObservedObject var userInfo: UserInformation
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Plant.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Plant.name, ascending: true)
        ]
    ) var plants: FetchedResults<Plant>
    
    @State var isPresented = false
    
    init(userInfo: UserInformation) {
//        if #available(iOS 14.0, *) {
//            // iOS 14 doesn't have extra separators below the list by default.
//        } else {
//            // To remove only extra separators below the list:
//            UITableView.appearance().tableFooterView = UIView()
//        }
//
//        // To remove all separators including the actual ones:
//        UITableView.appearance().separatorStyle = .none
        self.userInfo = userInfo
    }

    
    var body: some View {
        TabView {
            NavigationView {
                List {
                    ForEach(plants, id: \.name) {
                        PlantRow(plant: $0)
                    }
                    .onDelete(perform: deletePlant)
                }
                .sheet(isPresented: $isPresented) {
                    AddPlant { name, date_added, image in
                        self.addPlant(name: name, date_added: date_added, image: image)
                        self.isPresented = false
                    }
                }
                .navigationBarTitle(Text("My Plants"))
                .navigationBarItems(trailing:
                                        Button(action: { self.isPresented.toggle() }) {
                                            Image(systemName: "plus")
                                        }.frame(width: 50, height: 50)
                )
            }
           .tabItem {
                Image(systemName: "1.circle")
                Text("My Plants")
            }.tag(0)
            
            NavigationView {
                List {
                    Text("Profile")
                    VStack {
                        Button(action: {
                            SessionManager.shared.logout() {
                                userInfo.currentUserInfo = nil
                            }
                        }) {
                            Text("Log Out")
                        }
                    }
                }.navigationBarTitle(Text("Settings"))
            }.tabItem {
                Image(systemName: "2.circle")
                Text("Settings")
            }.tag(1)
          
        }
    }
    
    func deletePlant(at offsets: IndexSet) {
        offsets.forEach { index in
            let plant = self.plants[index]
            self.managedObjectContext.delete(plant)
        }
        saveContext()
    }
    
    
    func addPlant(name: String, date_added: Date, image: String?) {
        let newPlant = Plant(context: managedObjectContext)
        newPlant.name = name
        newPlant.date_added = Date()
        /* TODO: add image to Plant core data */
        
        saveContext()
    }
    
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

struct PlantList_Previews: PreviewProvider {
    static var previews: some View {
        PlantList(userInfo: UserInformation())
    }
}


