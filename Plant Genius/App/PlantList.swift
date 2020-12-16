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
        self.userInfo = userInfo
    }

    
    var body: some View {
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


