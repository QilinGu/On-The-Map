//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Gu Qilin on 12/28/15.
//  Copyright (c) 2015 SummerTree. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    var session: NSURLSession
    var studentLocations: [StudentInformation]?
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constant.baseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        //var jsonifyError: NSError? = nil
        
        request.HTTPMethod = "GET"
        request.addValue(Constant.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constant.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) {
            data, response, errorRequest in
            
            if let error = errorRequest {
                completionHandler(result: nil, error: error)
            } else {
                ParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
            
        }
        
        task.resume()
        return task
    }
    
    
    func taskForPOSTMethod(methods: String, postParams: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constant.baseURL + methods
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        //var jsonifyError: NSError? = nil
        request.HTTPMethod = "POST"
        request.addValue(Constant.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constant.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        /*
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: [])
        } catch let error as NSError {
            //jsonifyError = error
            request.HTTPBody = nil
        }
        */
        let task = session.dataTaskWithRequest(request) {
            data, response, errorRequest in
            if let error = errorRequest {
                completionHandler(result: nil, error: error)
            } else {
                ParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        return task
    }
    
    func taskForPUTMethod(methods: String, postParams: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constant.baseURL + methods
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)

        request.HTTPMethod = "PUT"
        request.addValue(Constant.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constant.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTaskWithRequest(request) {
            data, response, errorRequest in
            if let error = errorRequest {
                completionHandler(result: nil, error: error)
            } else {
                ParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        return task
    }
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }

}