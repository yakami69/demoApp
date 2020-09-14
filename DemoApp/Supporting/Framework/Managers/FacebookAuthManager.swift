//
//  FacebookAuthManager.swift
//  
//
//  Created by Narendra Bdr Kathayat on 12/30/19.
//

import Foundation
import FacebookCore
import FacebookLogin
import Combine

/// FACEBOOK NOT SUPPORTED
public final class FacebookLoginManager {
    
    
    /// The facebookManager instance
    private let loginManager: LoginManager
    
    /// The publisher for the facebook user
    public let facebookResponse = PassthroughSubject<Result<FacebookUser, Error>, Never>()
    
    /// Init`
    public init() {
        self.loginManager = LoginManager()
    }
    
    /// checkes wheather user login with facebook or not
    public var isLoggedIn: Bool {
        return AccessToken.current != nil
    }
    
    /// logout from facebook session
    public func logout() {
        loginManager.logOut()
    }
    
    /// Performs the start of login process from facebook
    /// - Parameter controller: the controller to present on
    public func performLogin(_ controller: UIViewController?) {
        loginManager.logOut()
        loginManager.logIn(permissions: ["email"], from: controller) {[weak self] (loginResult, error) in
            guard let self = self else { return }
            if let error = error {
                self.facebookResponse.send(.failure(error))
            } else if let result = loginResult {
                if let token = result.token {
                    self.getDataFromFacebook(with: token)
                } else if result.isCancelled {
                    self.facebookResponse.send(.failure(NetworkingError.facebookCancelled))
                } else {
                    self.facebookResponse.send(.failure(NetworkingError.custom("Unable to process Facebook request. Please try again later.")))
                }
            } else {
                self.facebookResponse.send(.failure(NetworkingError.custom("Unable to process Facebook request. Please try again later.")))
            }
        }
    }
    
    /// Method to fetch the user required data from GraphAPI and build into FacebookUser struct
    /// - Parameter token: the acces token after login
    private func getDataFromFacebook(with token: AccessToken) {
        GraphRequest(graphPath: "me", parameters: ["fields": "email,first_name,last_name"]).start { [weak self] (connection, data, error) in
            guard let self = self else { return }
            if let error = error {
                self.loginManager.logOut()
                self.facebookResponse.send(.failure(error))
            } else {
                guard let data = data as? [String: Any] else {
                    self.loginManager.logOut()
                    self.facebookResponse.send(.failure(NetworkingError.custom("Unable to login with facebook at the moment. Please try again later.")))
                    return
                }
                
                let firstName = data["first_name"] as? String ?? ""
                let lastName = data["last_name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let id = data["id"] as? String ?? ""
                let accesToken = token.tokenString
                
                let facebookUser = FacebookUser(accessToken: accesToken, facebookId: id, firstName: firstName, lastName: lastName, email: email)
                self.facebookResponse.send(.success(facebookUser))
            }
        }
    }
}
