//
//  AuthManager.swift
//  spotify
//
//  Created by Naman Jain on 12/05/21.
//

import Foundation
import UIKit

class AuthManager{
    static let sharedInstance = AuthManager()
    
    struct Constants {
        static let clientID = "5593ca7e539b4cfbb0d5f4e563ea9009"
        static let clientSecretCode = "812500bab1254819b8f2a9a47daaf93c"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }
    
    private init(){}
    
    public var signInUrl: URL?{
        let base = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private"
        let redirectURI = "https://www.iosacademy.io"
        let stringUrl = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: stringUrl)
    }
    
    
    var isSignedIn:Bool {
        return accessToken != nil
    }
    
    private var accessToken: String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool{
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let fiveMinute = 300
        let currentTime = Date().addingTimeInterval(TimeInterval(fiveMinute))
        
        return currentTime >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool)->Void)
    ){
        //get token
        
        guard let url = URL(string: Constants.tokenAPIURL) else{
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://www.iosacademy.io")
        ]
        //URLComponents are the components which should be passed along with the url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //the "Content-type" is a header that indicates the format of response sent to the client
        request.httpBody = components.query?.data(using: .utf8) //defining the httpBody
        let basicToken = Constants.clientID+":"+Constants.clientSecretCode
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else{
            print("failure to get base64String")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        //creating a url session
        let task = URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
            guard let data = data, error == nil else{
                completion(false)
                return
            }
            do{
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                completion(true)
                self?.cacheToken(result: result)
            }
            catch{
                print("error \(error.localizedDescription)")
                completion(false)
            }
            
        }
        task.resume()   //resuming the task
    }
    
    public func refreshIfNeeded(completion: @escaping (Bool)->Void){
        //refresh
        guard let url = URL(string: Constants.tokenAPIURL) else{
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        //URLComponents are the components which should be passed along with the url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //the "Content-type" is a header that indicates the format of response sent to the client
        request.httpBody = components.query?.data(using: .utf8) //defining the httpBody
        let basicToken = Constants.clientID+":"+Constants.clientSecretCode
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else{
            print("failure to get base64String")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        //creating a url session
        let task = URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
            guard let data = data, error == nil else{
                completion(false)
                return
            }
            do{
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("successfully refreshed")
                completion(true)
                self?.cacheToken(result: result)
            }
            catch{
                print("error \(error.localizedDescription)")
                completion(false)
            }
            
        }
        task.resume()   //resuming the task
    }
    
    private func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token , forKey: "access_token")
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.setValue(refresh_token , forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate" )
    }
    
}
