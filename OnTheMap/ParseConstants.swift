//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Gu Qilin on 12/28/15.
//  Copyright (c) 2015 SummerTree. All rights reserved.
//

import Foundation


extension ParseClient {
    
    struct Constant {
        
        //URLs
        static let baseURL: String = "https://api.parse.com/1/classes/"
        
        //Parse app id and key
        static let appID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
    }
    
    struct Methods {
        
        static let StudentLocations = "StudentLocation"
        
    }
    
    struct JSONResponseKeys {
        
        static let FirstName: String = "firstName"
        static let LastName: String = "lastName"
        static let Latitude: String = "latitude"
        static let Longitude: String = "longitude"
        static let MapString: String = "mapString"
        static let MediaURL: String = "mediaURL"
        static let ObjectId: String = "objectId"
        static let UniqueKey: String = "uniqueKey"
        static let Results: String = "results"
        static let Error: String = "error"
        static let UpdateAt: String = "updatedAt"
        
    }
}