//
//  ParseRequests.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/14/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ParseClient {
    
    func postStudentInfo (_ input: [String], _ completion: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let parameters = [String: String]()
        let user = UdacityClient.sharedInstance().userInfo!
        let id = UdacityClient.sharedInstance().userID!
        var request: URLRequest!
        
        if StudentInformation.studentLocation == nil {
            request = URLRequest(url: urlWithParameters(ParseClient.Methods.GetLocations, parameters: parameters))
            
            request.httpMethod = "POST"
        }else{
            request = URLRequest(url: urlWithParameters(ParseClient.Methods.GetLocWithID.replacingOccurrences(of: "[objectId]", with: "\(ParseClient.sharedInstance().objectID!)"), parameters: parameters))
            
            request.httpMethod = "PUT"
        }
        
        let f = user["first_name"] as! String?
        let l = user["last_name"] as! String?
        let loc = input[0]
        let link = input[1]
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(loc) { (placemarks, error) in
            
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                completion(false, "Location cannot be transalated")
                return
            }
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            request.httpBody = "{\"uniqueKey\": \"\(id)\", \"firstName\": \"\(f!)\", \"lastName\": \"\(l!)\",\"mapString\": \"\(loc)\", \"mediaURL\": \"\(link)\",\"latitude\": \(lat), \"longitude\": \(lon)}".data(using: .utf8)
            
            request.addValue(Constants.ApId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                func reportError(_ error: String) {
                    completion(false, error)
                    return
                }
                
                guard error == nil else {
                    reportError("Recieved an error while posting info")
                    return
                }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    reportError("Your request returned a status code other than 2xx!")
                    return
                }
                
                completion(true, nil)
            }
            
            task.resume()
        }
    }
    
    func getPostedData (_ completion: @escaping (_ success: Bool, _ error: String?, _ data: [[String: Any]]?) -> Void) {
        let parameters = [ParameterKeys.Limit   : ParameterValues.MaxLimit,
                          ParameterKeys.Order   : ParameterValues.DescendingUpdate]
        
        var request = URLRequest(url: urlWithParameters(ParseClient.Methods.GetLocations, parameters: parameters))
        request.addValue(Constants.ApId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            func reportError(_ error: String) {
                completion(false, error, nil)
                return
            }
            
            guard error == nil else {
                reportError("Recieved an error while requesting for sessionId")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                reportError("Your request returned a status code other than 2xx!")
                return
            }
            
            let parsedData: [String: AnyObject]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
            } catch {
                reportError("Error deserializing and parsing data.")
                return
            }
            
            guard let resultsDict = parsedData[ResponseKeys.Results] as! [[String: Any]]? else {
                    reportError("Recieved error extracting results dict in \(parsedData).")
                    return
            }
            
            completion(true, nil, resultsDict)
        }
    
        task.resume()
    }
    
    func getStudentLocation(_ completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        var parameters: [String: String]?
            
        if objectID == nil {
            parameters = ["where"   : "{\"uniqueKey\":\"\(UdacityClient.sharedInstance().userID!)\"}"]
        } else {
            parameters = ["where"   : "{\"uniqueKey\":\"\(UdacityClient.sharedInstance().userID!)\",\"objectId\":\"\(objectID!)\"}"]
        }
        
        let string = urlWithParameters(ParseClient.Methods.GetLocations, parameters: parameters!)
        var request = URLRequest(url: string)
        request.addValue(Constants.ApId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            func reportError(_ error: String) {
                completion(false, error)
                return
            }
            
            guard error == nil else {
                reportError("Recieved an error while requesting for sessionId")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                reportError("Your request returned a status code other than 2xx!")
                return
            }
            
            let parsedData: [String: AnyObject]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
            } catch {
                reportError("Error deserializing and parsing data.")
                return
            }
            guard let resultsArray = parsedData[ResponseKeys.Results] as! [[String: Any]]? else {
                    reportError("Error extracting results array")
                    return
            }
            
            if ParseClient.sharedInstance().objectID == nil {
                guard let id = resultsArray[0]["objectId"] as! String? else {
                    reportError("Error extracting results array")
                    return
                }
                
                StudentInformation.studentLocation = StudentInformation.init(resultsArray[0])
                ParseClient.sharedInstance().objectID = id
            } else {
                for dict in resultsArray {
                    if self.objectID == dict["objectId"] as! String? {
                        StudentInformation.studentLocation = StudentInformation.init(dict)
                        break
                    }
                }
            }
            
            completion(true, nil)
        }
        
        task.resume()
    }
    
    func storeStudentLocations(_ data: [[String: Any]]){
        var loc = [StudentInformation]()
        
        for student in data {
            let sL = StudentInformation(student)
            loc.append(sL)
        }
        
       StudentInformation.locations = loc
    }
}
