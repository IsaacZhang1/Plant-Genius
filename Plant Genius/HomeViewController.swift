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
    @State var showSplashView = true
    
    var body: some View {
        NavigationView {
            if self.showSplashView == true {
                Print("inside showSplashView")
                SplashView()
            }
            else if userInfo.currentUserInfo == nil {
                Print("inside userInfo == nil")
                LoginView(userInfo: userInfo)
//                SplashView()
            } else {
                Print("inside HomeViewController PlantList")
                PlantList(userInfo: userInfo)
            }
        }.onAppear {
            self.checkToken() {
                self.showSplashView = false
                userInfo.currentUserInfo = nil
            }
            print("HomeViewController appeared!")
        }
    }
    
    fileprivate func checkToken(callback: @escaping () -> Void) {
        SessionManager.shared.retrieveProfile { error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed to retrieve profile: \(String(describing: error))")
                    return callback()
                }
                print("iz: inside checkToken with successful retreival: \(SessionManager.shared.profile?.name)")
                self.showSplashView = false
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

