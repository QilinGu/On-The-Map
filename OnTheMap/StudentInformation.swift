//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Qilin Gu on 12/29/15.
//  Copyright (c) 2015 SummerTree. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    
    var firstName : String = ""
    var lastName : String = ""
    var latitude : Double = 0
    var longitude : Double = 0
    var mapString : String = ""
    var mediaURL : String = ""
    var objectId : String = ""
    var uniqueKey : String = ""
    var updatedAt : String = ""
    var hasPosted: Bool! = false
    
    init(dictionary: [String : AnyObject]) {
        
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        objectId = dictionary["objectId"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        updatedAt = dictionary["updatedAt"] as! String
        
    }
    
    static func studentInformationFromResults(results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        for result in results {
            
            students.append(StudentInformation(dictionary: result))
            
        }
        return students
    }
}