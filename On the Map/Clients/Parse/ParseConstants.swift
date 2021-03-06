//
//  ParseConstants.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/14/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct Constants {
        static let ApId     = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey   = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let Scheme   = "https"
        static let Host     = "parse.udacity.com"
    }
    
    struct Methods {
        static let GetLocations = "/parse/classes/StudentLocation"
        static let GetLocWithID = "/parse/classes/StudentLocation/[objectId]"
    }
    
    struct ParameterKeys {
        static let Limit    = "limit"
        static let Order    = "order"
    }
    
    struct ParameterValues {
        static let AscendingUpdate  = "updatedAt"
        static let DescendingUpdate = "-updatedAt"
        static let MaxLimit         = "100"
    }
    
    struct ResponseKeys {
        static let First        = "firstName"
        static let Last         = "lastName"
        static let Lat          = "latitude"
        static let Lon          = "longitude"
        static let Url          = "mediaURL"
        static let MapString    = "mapString"
        static let Results      = "results"
    }
}
