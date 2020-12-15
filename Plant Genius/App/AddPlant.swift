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
    @State var showCaptureImageView: Bool = false
    
    @State var name = ""
    @State var date_added = Date()
    @State var image: String?
    let onComplete: (String, Date, String?) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
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
                        Button(action: {
                            self.showCaptureImageView.toggle()
                        }) {
                            Image(systemName: "camera").resizable()
                                .frame(width: CGFloat(30), height: CGFloat(25))
                        }
                    }
                }
                .navigationBarTitle(Text("Add Plant"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: addPlantAction) {
                    Text("Add")
                })
                if (showCaptureImageView) {
                    Print("iz: before CaptureImageView with showCaptureImageView of \(showCaptureImageView)")
                    CaptureImageView(isShown: $showCaptureImageView, mediaType: .Camera) { returnedImage in
                        Print("iz: the returned image is: \(returnedImage)")
                        saveImage(imageName: name, image: returnedImage)
                    }
                }
            }
        }
    }
    
    private func addPlantAction() {
        onComplete(
            name.isEmpty ? AddPlant.DefaultPlantName : name,
            date_added,
            image)
    }
}
