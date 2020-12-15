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
    var showSplashView: Bool = true

}

struct HomeViewController: View {
    @ObservedObject var userInfo: UserInformation = UserInformation()
    
    init() {
        checkToken()
    }
    
    var body: some View {
        if self.userInfo.showSplashView == true {
            SplashView()
        } else if userInfo.currentUserInfo == nil {
            LoginView(userInfo: userInfo)
        } else {
            PlantList(userInfo: userInfo)
        }
    }
    
    fileprivate func checkToken() {
        SessionManager.shared.retrieveProfile { error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed to retrieve profile: \(String(describing: error))")
                    userInfo.currentUserInfo = nil
                    userInfo.showSplashView = false
                    return
                }
                userInfo.showSplashView = false
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

