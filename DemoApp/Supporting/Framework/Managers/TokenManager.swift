//
//  TokenManager.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/31/19.
//

import Foundation
import Alamofire
import Combine

/// Class That will manage the tokenRefresh is needed
public class TokenManager {
    
    /// The cache manager to retrive the token info from cache and store if refreshed
    private let cacheManager: CacheManager
    
    /// The current token
    private lazy var currentToken: Token? = {
        return self.cacheManager.getObject(type: Token.self, forKey: FrameworkCacheKey.token)
    }()
    
    /// The auth header
    var authHeader: HTTPHeader? {
        guard let token = token else { return nil }
        return HTTPHeader.authorization(token.accessToken)
    }
    
    /// The current token
    public var token: Token? {
        return self.cacheManager.getObject(type: Token.self, forKey: FrameworkCacheKey.token)
    }
    
    /// The endpoint path of the token refresh API
    private let endPath: String
    
    /// Intializer
    public init(cacheManager: CacheManager, enpointPath: String = "auth/refreshToken") {
        self.endPath = enpointPath
        self.cacheManager = cacheManager
    }
    
    /// Method to check wether a request token is valid or need refresh
    /// If it need refresh this method will call appropriate refresh method and save the token
    /// - Parameter router: the router to check if it actaully requires token for request
    func hasValidToken(router: NetworkingRouter, isForced: Bool = false) -> AnyPublisher<NetworkingResult<Token>, Never> {
        if isForced {
            return validateOrRefreshToken(isForced: isForced)
        } else if router.needTokenValidation {
            return validateOrRefreshToken()
        } else {
            return Just(NetworkingResult(router: EraserRouter.none)).eraseToAnyPublisher()
        }
    }
    
    /// Method that will check the validity of the token and return success on valid token
    /// Or this method will ask to refresh the token
    func validateOrRefreshToken(isForced: Bool = false) -> AnyPublisher<NetworkingResult<Token>, Never> {
        
        /// check we have the token in cache
        guard let token = currentToken,
            let expiresIn = Double(token.accessExpiresIn) else {
                return Just(NetworkingResult(success: false, error: .tokenValidationFailed, router: EraserRouter.none)).eraseToAnyPublisher()
        }
        
        // if forced then directly refresh token
        if isForced {
            return refreshToken(token)
        }
        
        //check validity and refresh if needed
        if Date().timeIntervalSince(token.refreshedDate) >= expiresIn {
            return refreshToken(token)
        }
        
        //return success if everything is neat and tidy
        return Just(NetworkingResult(router: EraserRouter.none)).eraseToAnyPublisher()
    }
    
    /// Method to actually refresh the token
    private func refreshToken(_ token: Token) -> AnyPublisher<NetworkingResult<Token>, Never> {
        let parameters: [String: Any] = ["refreshToken": token.refreshToken]
        
        return Future<NetworkingResult<Token>, Never> { [weak self] promise in
            guard let self = self else { return }
            AF.request("\(Config.default.serverURL.appendingPathComponent(self.endPath))", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Config.default.httpHeaders(addingHeader: [self.authHeader]))
                .validate()
                .responseJSON(completionHandler: {(jsonResponse) in
                    Logger.shared.log(jsonResponse)
                    switch jsonResponse.result {
                    case .success(let value):
                        let result = self.parseAndSaveToken(jsonResponse, value: value)
                        promise(.success(result))
                    case .failure(let error):
                        promise(.success(NetworkingResult(success: false, error: .tokenRefreshFailed(error), statusCode: jsonResponse.response?.statusCode ?? 0, router: EraserRouter.none)))
                    }
                })
        }
        .eraseToAnyPublisher()
    }
    
    /// Method to parse and save the token to cache
    /// - Parameter response: the response of token refresh
    private func parseAndSaveToken(_ response: AFDataResponse<Any>, value: Any) -> NetworkingResult<Token> {
        
        //get the token either from header or body
        let json = extractTokenInfoFromResponseIfPresent(response) ?? extractTokenFromValue(value: value)
        guard let tokenJSON = json else {
            return NetworkingResult(success: false, error: .tokenRefreshFailed(nil), router: EraserRouter.none)
        }
        
        // try to get the token object
        do {
            let tokenData = try JSONSerialization.data(withJSONObject: tokenJSON, options: .prettyPrinted)
            let tokenObject = try JSONDecoder().decode(Token.self, from: tokenData)
            let saved = cacheManager.saveObject(type: Token.self, object: tokenObject, key: FrameworkCacheKey.token)
            NotificationCenter.default.post(name: Notification.Name("tokenRefreshed"), object: nil)
            return NetworkingResult(success: saved, error: .tokenRefreshFailed(nil), router: EraserRouter.none)
        } catch {
            return NetworkingResult(success: false, error: .tokenRefreshFailed(error), router: EraserRouter.none)
        }
    }
    
    /// Method to extract token from data in sucess response
    /// - Parameter value: the value of response
    private func extractTokenFromValue(value: Any) -> [String: Any]? {
        guard let data = value as? [String: Any], let json = data["data"] as? [String: Any] else { return nil }
        return getValuesFromJSON(json)
    }
    
    /// Our Auth token data is received through response headers, so we have to parse those objects from header fields
    ///
    /// - Parameter response: the response received
    /// - Returns: generated token data
    private func extractTokenInfoFromResponseIfPresent(_ response: AFDataResponse<Any>) -> [String: Any]? {
        guard let allHTTPHeaders = response.response?.allHeaderFields else { return nil }
        return getValuesFromJSON(allHTTPHeaders)
    }
    
    /// Method to get the proper json for token from the response json
    /// - Parameter json: the token json
    private func getValuesFromJSON(_ json: [AnyHashable: Any]) -> [String: Any]? {
        //we are looking for three keys for token, all three must be present for valid refresh
        guard let accessToken = json[Token.CodingKeys.accessToken.rawValue],
            let refreshToken = json[Token.CodingKeys.refreshToken.rawValue],
            let expiresIn = json[Token.CodingKeys.refreshExpiresIn.rawValue],
            let accessExpiresIn = json[Token.CodingKeys.accessExpiresIn.rawValue] else { return nil }
        
        //now we build the parseable JSON object
        let tokenJSON: [String: Any] = [Token.CodingKeys.accessToken.rawValue: accessToken,
                                        Token.CodingKeys.refreshToken.rawValue: refreshToken,
                                        Token.CodingKeys.refreshExpiresIn.rawValue: expiresIn,
                                        Token.CodingKeys.objectId.rawValue: "AuthToken",
                                        Token.CodingKeys.accessExpiresIn.rawValue: accessExpiresIn]
        
        return tokenJSON
    }
}
