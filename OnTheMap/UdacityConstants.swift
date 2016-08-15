//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Fan Xiaoyu on 12/29/15.
//  Copyright (c) 2015 SummerTree. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constant {
        static let baseURL: String = "https://www.udacity.com/"
    }
    
    struct Methods {
        static let UserSession = "api/session"
        static let UserData = "api/users/{user_id}"
    }
    
    struct URLKeys {
        static let userID = "user_id"
    }
}