//
//  UdacityConstants.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/9/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation

extension UdacityClient {

    struct Methods {
        static let Session      = "https://www.udacity.com/api/session"
        static let UserInfo     = "https://www.udacity.com/api/users/[id]"
    }
    
    struct ResponseKeys {
        static let ID           = "id"
        static let Registered   = "registered"
        static let Session      = "session"
        static let Account      = "account"
        static let Key          = "key"
        static let User         = "user"
    }
}
