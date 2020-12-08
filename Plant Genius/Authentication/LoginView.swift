//
//  LoginView.swift
//  Plant Genius
//
//  Created by Isaac Zhang on 12/7/20.
//  Copyright © 2020 Isaac Zhang. All rights reserved.
//

import SwiftUI
import UIKit
import Auth0


struct LoginView: View {
    @ObservedObject var userInfo: UserInformation
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    showLock()
                }) {
                    Text("Login")
                }
            }
        }
    }
    
    fileprivate func showLock() {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        print("the profile before is: \(SessionManager.shared.profile)")
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://dev-sm77edt6.us.auth0.com/userinfo")
            .start { result in
                switch result {
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                case .success(let credentials):
                    // Do something with credentials e.g.: save them.
                    // Auth0 will automatically dismiss the login page
                    print("Credentials: \(credentials)")
                    guard let accessToken = credentials.accessToken, let idToken = credentials.idToken else { return }
                    SessionManager.shared.storeTokens(accessToken, idToken: idToken)
                    SessionManager.shared.retrieveProfile { error in
                        print("Profile is: \(SessionManager.shared.profile)")
                        guard error == nil else {
                            return self.showLock()
                        }
                        DispatchQueue.main.async {
                            print("Setting userInfo is: \(SessionManager.shared.profile)")
                            userInfo.currentUserInfo = SessionManager.shared.profile
//                            self.performSegue(withIdentifier: "ShowProfileNonAnimated", sender: nil)
                        }
                    }
                }
        }
    }
    
    fileprivate func checkAccessToken() {
//        let loadingAlert = UIAlertController.loadingAlert()
//        loadingAlert.presentInViewController(viewController: self)
        SessionManager.shared.retrieveProfile { error in
            DispatchQueue.main.async {
                guard error == nil else {
                    return self.showLock()
                }
                
               /** TODO: set the authenticated status to true */
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(userInfo: UserInformation())
    }
}

