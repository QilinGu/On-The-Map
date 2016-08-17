//
//  UserPins.swift
//  OnTheMap
//
//  Created by Fan Xiaoyu on 8/17/16.
//  Copyright © 2016 SummerTree. All rights reserved.
//

import Foundation

class UserPins {
    
    var users: [StudentInformation] = [StudentInformation]()
    
    class func sharedInstance() -> UserPins {
        struct Singleton {
            static var sharedInstance = UserPins()
        }
        
        return Singleton.sharedInstance
    }
    
}