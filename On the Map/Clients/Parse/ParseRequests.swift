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
    
    func postStudentInfo (_ hostView: SuccessfulPostController) {
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
        let loc = hostView.locationInput!
        let link = hostView.linkInput!
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(loc) { (placemarks, error) in
            
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                    print("Location cannot be transalated")
                    hostView.indicator.stopAnimating()
                    let alert = UIAlertController(title: "Location Error", message:
                        "The location entered is not valid.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    hostView.present(alert, animated: true, completion: nil)
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
                    print(error)
                    DispatchQueue.main.async {
                        hostView.alertFailure()
                    }
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
                
                self.getStudentLocation(hostView)
            }
            
            task.resume()
        }
    }
    
    func getPostedData (_ hostView: TabBarController){
        let parameters = [ParameterKeys.Limit   : ParameterValues.MaxLimit,
                          ParameterKeys.Order   : ParameterValues.DescendingUpdate]
        
        var request = URLRequest(url: urlWithParameters(ParseClient.Methods.GetLocations, parameters: parameters))
        request.addValue(Constants.ApId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            func reportError(_ error: String) {
                print(error)
                StudentInformation.locations = [StudentInformation]()
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
            
            hostView.getMap().removeAnnotations(ParseClient.sharedInstance().annotations)
            self.storeStudentLocations(resultsDict)
            ParseClient.sharedInstance().generateAnnotations()
            
            ParseClient.sharedInstance().getStudentLocation()
            
            DispatchQueue.main.async {
                hostView.getMap().addAnnotations(ParseClient.sharedInstance().annotations)
                hostView.table?.reloadData()
            }
        }
    
        task.resume()
    }
    
    func getStudentLocation(_ hostView: Any? = nil) {
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
                print(error)
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
            
            if hostView != nil {
                let student = StudentInformation.studentLocation!
                
                let lat = CLLocationDegrees(student.lat!)
                let long = CLLocationDegrees(student.lon!)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(student.first!) \(student.last!)"
                annotation.subtitle = student.url
                
                (hostView as! SuccessfulPostController).map.addAnnotation(annotation)
                DispatchQueue.main.async {
                    (hostView as! SuccessfulPostController).zoomOnPin(coordinate)
                }
            }
            
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
