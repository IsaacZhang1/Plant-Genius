//
//  HomeViewController.swift
//  Plant Genius
//
//  Created by Isaac Zhang on 12/7/20.
//  Copyright © 2020 Isaac Zhang. All rights reserved.
//

import SwiftUI
import Auth0

class UserInformation: ObservableObject {
    @Published var currentUserInfo: UserInfo?

}

struct HomeViewController: View {
    @ObservedObject var userInfo: UserInformation = UserInformation()
    
    var body: some View {
        if userInfo.currentUserInfo == nil {
            LoginView(userInfo: userInfo)
        } else {
            PlantList()
        }
    }
}



struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController()
    }
}
