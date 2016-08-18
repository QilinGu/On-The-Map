//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Fan Xiaoyu on 12/29/15.
//  Copyright (c) 2015 SummerTree. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // Constants
    struct Constants {
        
        // API Key
        static let ApiKey : String = "53458e624397a1be92da00f2ecdd0de9"
        static let UdacityURLSecure : String = "https://www.udacity.com/"
        
    }
    
    struct Methods {
        
        // Udacity
        static let UdacitySession = "api/session"
        static let UdacityUser = "api/users/{uniqueKey}"
        
        // Authentication
        static let AuthenticationTokenNew = "authentication/token/new"
        static let AuthenticationSessionNew = "authentication/session/new"
        
        // Config
        static let Config = "configuration"
        
    }
    
    // URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        static let UniqueKey = "uniqueKey"
        
    }
    
    // Parameter Keys
    struct ParameterKeys {
        
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        
        static let Dummy = "dummy"
        
    }
    
    struct Error {
        
        static let UdacityDomainError = "UdacityDomainError"
        
    }
    
    // JSON Body Keys
    struct JSONBodyKeys {
        
        static let FacebookMobile = "facebook_mobile"
        
        static let AccessToken = "access_token"
        
        static let Udacity = "udacity"
        static let UdacityUsername = "username"
        static let UdacityPassword = "password"
        static let UdacityUserUniqueKey = "uniqueKey"
        
    }
    
    // JSON Response Keys
    struct JSONResponseKeys {
        
        static let UdacityStatus = "status"
        
        static let UdacityUser = "user"
        static let UdacityUserFirstName = "first_name"
        static let UdacityUserLastName = "last_name"
        
        static let UdacityAccount = "account"
        static let UdacityAccountRegistered = "registered"
        static let UdacityAccountKey = "key"
        
        static let UdacitySession = "session"
        static let UdacitySessionID = "id"
        static let UdacitySessionExpiration = "expiration"
        
        // General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // Account
        static let Account = "account"
        static let Key = "key"
        static let Status = "status"
        static let UserID = "id"
        
    }
}