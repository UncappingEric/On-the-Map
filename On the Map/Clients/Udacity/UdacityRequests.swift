//
//  UdacityRequests.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/9/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    func logOff(_ completion: @escaping (_ success: Bool, _ error: String?)-> Void) {
        var request = URLRequest(url: URL(string: Methods.Session)!)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            func showAlert(_ error: String) {
                completion(false, error)
                return
            }
            
            guard (error == nil) else{
                showAlert("Error logging off.")
                return
            }
            
            let newData = data?.subdata(in: Range(5..<data!.count)) /* subset response data! */
            
            let parsedData: [String: AnyObject]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String: AnyObject]
            } catch {
                showAlert("Error deserializing and parsing data.")
                return
            }
            
            guard let sessionDict = parsedData[ResponseKeys.Session] as! [String: Any]?,
                let _ = sessionDict[ResponseKeys.ID] as! String? else {
                    showAlert("Recieved error extracting session dict or id value.")
                    return
            }
            
           completion(true, nil)
        }
        task.resume()
    }
    
    func getSessionId(_ input: [String], _ completion: @escaping (_ success: Bool, _ error: [String]?)-> Void) {
        
        var request = URLRequest(url: URL(string: UdacityClient.Methods.Session)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(input[0])\", \"password\": \"\(input[1])\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            func reportError(_ error: String, labelString: String = "Error with connection.") {
                completion(false, [error, labelString])
                return
            }
            
            guard error == nil else {
                reportError("Recieved an error while requesting for sessionId")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                reportError("Your request returned a status code other than 2xx!", labelString: "Invalid user/password combination.")
                return
            }
            
            let newData = data?.subdata(in: Range(5..<data!.count)) /* subset response data! */
            
            let parsedData: [String: AnyObject]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String: AnyObject]
            } catch {
                reportError("Error deserializing and parsing data.")
                return
            }
            
            guard let accountDict = parsedData[ResponseKeys.Account] as! [String: Any]?,
                let sessionDict = parsedData[ResponseKeys.Session] as! [String: Any]? else {
                    reportError("Recieved error extracting account and/or session dicts in \(parsedData).")
                    return
            }
            
            guard let registered = accountDict[ResponseKeys.Registered] as! Bool?,
                let key = accountDict[ResponseKeys.Key] as! String?,
                let id = sessionDict[ResponseKeys.ID] as! String? else {
                    reportError("Recieved error extracting key, id, and/or registered values in \n\n\(accountDict)\n\nor\n\n\(sessionDict).")
                    return
            }
            
            if registered == false {
                reportError("User not registered", labelString: "Invalid user/password combination.")
                return
            }
            
            self.sessionID = id
            self.userID = key
            
            completion(true, nil)
        }
        task.resume()
    }
    
    func getUserInfo(_ completion: @escaping (_ success: Bool, _ error: [String]?) -> Void) {
        let urlString = URL(string: methodWithId(Methods.UserInfo))!
        let request = URLRequest(url: urlString)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            func reportError(_ error: String, labelString: String = "Error with connection.") {
                completion(false, [error, labelString])
                return
            }
            
            guard error == nil else {
                reportError("Recieved an error while requesting for user info")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                reportError("Your request returned a status code other than 2xx!")
                return
            }
            
            let newData = data?.subdata(in: Range(5..<data!.count)) /* subset response data! */
            
            let parsedData: [String: AnyObject]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String: AnyObject]
            } catch {
                reportError("Error deserializing and parsing data.")
                return
            }
            
            guard let userDict = parsedData[ResponseKeys.User] as! [String: Any]? else {
                    reportError("Recieved error extracting user dict.")
                    return
            }
            
            self.userInfo = userDict
            
            completion(true, nil)
        }
        task.resume()
    }
}
