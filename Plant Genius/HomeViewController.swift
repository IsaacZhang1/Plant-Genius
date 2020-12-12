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
    var showSplashView: Bool?

}

struct HomeViewController: View {
    @ObservedObject var userInfo: UserInformation = UserInformation()
//    @State var showSplashView = true
    
    init() {
        checkToken()
    }
    
    var body: some View {
        if self.userInfo.showSplashView == true {
            Print("inside showSplashView")
            SplashView()
        }
        else if userInfo.currentUserInfo == nil {
            Print("inside userInfo == nil")
            LoginView(userInfo: userInfo)
        } else {
            Print("inside HomeViewController PlantList")
            PlantList(userInfo: userInfo)
        }
    }
    
    fileprivate func checkToken() {
        userInfo.showSplashView = false
        SessionManager.shared.retrieveProfile { error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed to retrieve profile: \(String(describing: error))")
                    userInfo.currentUserInfo = nil
                    return
                }
                print("iz: inside checkToken with successful retreival: \(SessionManager.shared.profile?.name)")
                self.userInfo.currentUserInfo = SessionManager.shared.profile
            }
        }
           
    }
}



struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController()
    }
}

