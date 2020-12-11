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
                    AddPlant { name, date_added in
                        self.addPlant(name: name, date_added: date_added)
                        self.isPresented = false
                    }
                }
                .navigationBarTitle(Text("My Plants"))
                .navigationBarItems(trailing:
                                        Button(action: { self.isPresented.toggle() }) {
                                            Image(systemName: "plus")
                                        }
                )
            }
           .tabItem {
                Image(systemName: "1.circle")
                Text("My Plants")
            }.tag(0)
            
            NavigationView {
                VStack {
                    Button(action: {
                        SessionManager.shared.logout()
                        userInfo.currentUserInfo = nil
                    }) {
                        Text("Log Out")
                    }
                }
            }.tabItem {
                Image(systemName: "2.circle")
                Text("Second")
            }.tag(1)
          
        }
//        List {
//            ForEach(plants, id: \.name) {
//                PlantRow(plant: $0)
//            }
//            .onDelete(perform: deletePlant)
//        }
//        .sheet(isPresented: $isPresented) {
//            AddPlant { name, date_added in
//                self.addPlant(name: name, date_added: date_added)
//                self.isPresented = false
//            }
//        }
//        .navigationBarTitle(Text("My Plants"))
//        .navigationBarItems(trailing:
//                                Button(action: { self.isPresented.toggle() }) {
//                                    Image(systemName: "plus")
//                                }
//        )
    }
    
    func deletePlant(at offsets: IndexSet) {
        offsets.forEach { index in
            let plant = self.plants[index]
            self.managedObjectContext.delete(plant)
        }
        saveContext()
    }
    
    
    func addPlant(name: String, date_added: Date) {
        let newPlant = Plant(context: managedObjectContext)
        newPlant.name = name
        newPlant.date_added = Date()
        
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


