//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Fan Xiaoyu on 12/29/15.
//  Copyright (c) 2015 SummerTree. All rights reserved.
//

import Foundation

import Foundation
import UIKit

struct StudentInformation {
    
    var firstName: String!
    var lastName: String!
    var latitude: Double!
    var longitude: Double!
    var mapString: String!
    var mediaURL: String!
    var objectId: String!
    var uniqueKey: String! //"996618664",
    var updatedAt: String!
    
    init(dictionary: [String : AnyObject]) {
        
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdateAt] as! String
        
    }
    
    static func studentLocationsFromResults(results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var locations = [StudentInformation]()
        
        for result in results {
            
            locations.append(StudentInformation(dictionary: result))
            
        }
        
        locations.sortInPlace({$0.updatedAt > $1.updatedAt})
        return locations
    }
    
    
}