//
//  UserPins.swift
//  OnTheMap
//
//  Created by Qilin Gu on 8/18/16.
//  Copyright © 2016 SummerTree. All rights reserved.
//

import Foundation

class StudentPins {
    
    var students: [StudentInformation] = [StudentInformation]()
    
    class func sharedInstance() -> StudentPins {
        struct Singleton {
            static var sharedInstance = StudentPins ()
        }
        
        return Singleton.sharedInstance
    }
    
}