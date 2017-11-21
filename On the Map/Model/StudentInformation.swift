//
//  StudentInformation.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/21/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation

struct StudentInformation{
    
    static var studentLocation: StudentInformation?
    static var locations = [StudentInformation]()
    
    var first:  String?
    var last:   String?
    var lat:    Float?
    var lon:    Float?
    var mapString: String?
    var url:    String?
    
    init(_ dict: [String: Any]) {
        first        =   dict[ParseClient.ResponseKeys.First] as! String?
        last         =   dict[ParseClient.ResponseKeys.Last] as! String?
        lat          =   dict[ParseClient.ResponseKeys.Lat] as! Float?
        lon          =   dict[ParseClient.ResponseKeys.Lon] as! Float?
        mapString    =   dict[ParseClient.ResponseKeys.MapString] as! String?
        url          =   dict[ParseClient.ResponseKeys.Url] as! String?
    }
}
