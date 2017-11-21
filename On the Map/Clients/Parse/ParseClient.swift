//
//  ParseClient.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/14/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation
import MapKit

class ParseClient {
    
    var studentLocation: StudentInformation?
    var locations = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    var objectID: String?
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    func urlWithParameters(_ method: String, parameters: [String:String] = [:]) -> URL{
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.Scheme
        components.host = ParseClient.Constants.Host
        components.path = method
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }

        return components.url!
    }
    
    func generateAnnotations() {
        annotations = [MKPointAnnotation]()
        
        for student in locations {
            if let studentLat = student.lat,
                let StudentLon = student.lon {
                    let lat = CLLocationDegrees(studentLat)
                    let long = CLLocationDegrees(StudentLon)
                
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(student.first!) \(student.last!)"
                    annotation.subtitle = student.url
                
                    annotations.append(annotation)
            }
        }
    }
}

