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
    let credentialsManager = CredentialsManager(authentication: Auth0.authentication())

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    self.checkAccessToken()
                }) {
                    Text("Login")
                }
            }
        }
    }
    
    fileprivate func showLock() {
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://dev-sm77edt6.us.auth0.com/userinfo")
            .start { result in
                switch result {
                case .failure(let error):
                    print("Error: \(error)")
                case .success(let credentials):
                    guard let accessToken = credentials.accessToken, let idToken = credentials.idToken else { return }
                    SessionManager.shared.storeTokens(accessToken, idToken: idToken)
                    SessionManager.shared.retrieveProfile { error in
                        guard error == nil else {
                            print("the error in showLock is: \(error)")
                            return self.showLock()
                        }
                        DispatchQueue.main.async {
                            userInfo.currentUserInfo = SessionManager.shared.profile
                        }
                    }
                }
        }
    }
    
    fileprivate func checkAccessToken() {
        SessionManager.shared.retrieveProfile { error in
            DispatchQueue.main.async {
                guard error == nil else {
//                    return
                    return self.showLock()
                }
               /** TODO: set the authenticated status to true */
                userInfo.currentUserInfo = SessionManager.shared.profile

            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(userInfo: UserInformation())
    }
}

