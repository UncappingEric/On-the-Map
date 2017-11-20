//
//  UdacityClient.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/9/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    var sessionID: String?
    var userID: String?
    var userInfo: [String: Any]?
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    func methodWithId(_ method:String) -> String{
        return method.replacingOccurrences(of: "[id]", with: userID!)
    }
}
