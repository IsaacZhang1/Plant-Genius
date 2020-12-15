
import Foundation
import SimpleKeychain
import Auth0
import JWTDecode

enum SessionManagerError: Error {
    case noAccessToken
    case noIdToken
    case noProfile
    case missingRoles
}

class SessionManager {
    static let shared = SessionManager()
    let keychain = A0SimpleKeychain(service: "Auth0")

    var profile: UserInfo?

    private init () { }

    func storeTokens(_ accessToken: String, idToken: String) {
        self.keychain.setString(accessToken, forKey: "access_token")
        self.keychain.setString(idToken, forKey: "id_token")
    }

    func retrieveProfile(_ callback: @escaping (Error?) -> ()) {
        guard let accessToken = self.keychain.string(forKey: "access_token") else {
            return callback(SessionManagerError.noAccessToken)
        }
        Auth0.authentication()
            .userInfo(withAccessToken: accessToken)
            .start { result in
                switch(result) {
                case .success(let profile):
                    self.profile = profile
                    callback(nil)
                case .failure(let error):
                    callback(error)
                }
        }
    }

    func userRoles() -> [String]? {
        guard
            let idToken = self.keychain.string(forKey: "id_token"),
            let jwt = try? decode(jwt: idToken),
            let roles = jwt.claim(name: "https://example.com/roles").array
            else { return nil }

        return roles
    }

    
    func logout(_ callback: @escaping () -> Void) {
          // Remove credentials from KeyChain
        self.keychain.clearAll()
        callback()
      }

}

func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
    guard
        let path = bundle.path(forResource: "Auth0", ofType: "plist"),
        let values = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
            return nil
    }

    guard
        let clientId = values["ClientId"] as? String,
        let domain = values["Domain"] as? String
        else {
            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
            print("File currently has the following entries: \(values)")
            return nil
    }
    return (clientId: clientId, domain: domain)
}
