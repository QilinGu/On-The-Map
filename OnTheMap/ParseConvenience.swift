//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Gu Qilin on 12/28/15.
//  Copyright (c) 2015 SummerTree. All rights reserved.
//


import UIKit
import Foundation

extension ParseClient {
    
    func getCurrentUser(currentUser: StudentInformation, completionHandler: (result: StudentInformation?, error: NSError?) -> Void) {
        
        /* Parameters */
        let methodParameters = [
            ParameterKeys.Where: "{\"uniqueKey\":\"\(currentUser.uniqueKey)\"}"
        ]
        
        /* Build the URL */
        let urlString = (Constants.ParseURLSecure + Methods.GetStudentLocations) + UdacityClient.escapedParameters(methodParameters)
        let url = NSURL(string: urlString)!
        
        /* Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* Make the request */
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            
            if error != nil {
                let userInfo: NSDictionary = [
                    NSLocalizedDescriptionKey: error!.localizedDescription]
                
                let errorObject = NSError(domain: Error.ParseDomainError, code: 1, userInfo: userInfo as [NSObject : AnyObject])
                
                completionHandler(result: nil, error: errorObject)
            }
            else {
                
                /* Parse the data */
                let parsedJSON = (try! NSJSONSerialization.JSONObjectWithData(data!,
                    options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                
                /* Use the data */
                if let results = parsedJSON.valueForKey(JSONResponseKeys.Results) as? [[String : AnyObject]] {
                    if results.count > 0 {
                        let currentUser = StudentInformation(dictionary: results[0])
                        completionHandler(result: currentUser, error: nil)
                    }
                    else {
                        
                        let userInfo: NSDictionary = [NSLocalizedDescriptionKey: "Student does not exist"]
                        
                        let errorObject = NSError(domain: Error.ParseDomainError, code: 2, userInfo: userInfo as [NSObject : AnyObject])
                        
                        completionHandler(result: nil, error: errorObject)
                        
                    }
                } else {
                    
                    let userInfo: NSDictionary = [NSLocalizedDescriptionKey: "Could not parse Student information"]
                    
                    let errorObject = NSError(domain: Error.ParseDomainError, code: 2, userInfo: userInfo as [NSObject : AnyObject])
                    
                    completionHandler(result: nil, error: errorObject)
                    
                }
            }
            
        }
        
        /* Start the request */
        task.resume()
        
    }
    
    func getUsers(skip: Int = 0, completionHandler: (result: [StudentInformation]?, error: NSError?) -> Void) {
        
        /* Parameters */
        let methodParameters = [
            ParameterKeys.Limit: "100",
            ParameterKeys.Skip: "\(skip)",
            ParameterKeys.Order: "-updatedAt"
        ]
        
        /* Build the URL */
        let urlString = (Constants.ParseURLSecure + Methods.GetStudentLocations) + UdacityClient.escapedParameters(methodParameters)
        let url = NSURL(string: urlString)!
        
        /* Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* Make the request */
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil {
                
                let userInfo: NSDictionary = [NSLocalizedDescriptionKey: error!.localizedDescription]
                
                let errorObject = NSError(domain: Error.ParseDomainError, code: 1, userInfo: userInfo as [NSObject : AnyObject])
                
                completionHandler(result: nil, error: errorObject)
                
            }
            else {
                
                /* Parse the data */
                let parsedJSON = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                
                /* Use the data */
                if let results = parsedJSON.valueForKey(JSONResponseKeys.Results) as? [[String : AnyObject]] {
                    let students = StudentInformation.studentInformationFromResults(results)
                    completionHandler(result: students, error: nil)
                } else {
                    let userInfo: NSDictionary = [NSLocalizedDescriptionKey: "No students exist"]
                    
                    let errorObject = NSError(domain: Error.ParseDomainError, code: 2, userInfo: userInfo as [NSObject : AnyObject])
                    
                    completionHandler(result: nil, error: errorObject)
                }
            }
        }
        
        /* Start the request */
        task.resume()
    }
    
    func updateUserData(user: StudentInformation, completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        /* Build the URL */
        let objectID = user.objectId
        let urlString = (Constants.ParseURLSecure + Methods.GetStudentLocations) + "/\(objectID)"
        let url = NSURL(string: urlString)!
        
        /* Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody : [String:AnyObject] =
            [
                JSONBodyKeys.UniqueKey: user.uniqueKey,
                JSONBodyKeys.FirstName: user.firstName,
                JSONBodyKeys.LastName: user.lastName,
                JSONBodyKeys.MapString: user.mapString,
                JSONBodyKeys.MediaURL: user.mediaURL,
                JSONBodyKeys.Latitude: user.latitude,
                JSONBodyKeys.Longitude: user.longitude
        ]
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
        } catch {
            request.HTTPBody = nil
            print("exhaustiveness - parse")
        }
        
        /* Make the request */
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                
                let userInfo: NSDictionary = [NSLocalizedDescriptionKey: error!.localizedDescription]
                
                let errorObject = NSError(domain: Error.ParseDomainError, code: 1, userInfo: userInfo as [NSObject : AnyObject])
                
                completionHandler(success: false, error: errorObject)
            }
            else {
                /* Parse the data */
                let parsedJSON = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                
                /* Use the data */
                if let createdAt = parsedJSON.valueForKey(JSONResponseKeys.UpdatedAt) as? String {
                    print("createAt: \(createdAt)")
                    completionHandler(success: true, error: nil)
                } else {
                    
                    let userInfo: NSDictionary = [NSLocalizedDescriptionKey: "StudentLocation not updated"]
                    
                    let errorObject = NSError(domain: Error.ParseDomainError, code: 2, userInfo: userInfo as [NSObject : AnyObject])
                    
                    completionHandler(success: false, error: errorObject)
                }
            }
        }
        
        /* Start the request */
        task.resume()
    }
    
    func saveUserData(user: StudentInformation, completionHandler: (success: Bool, objectID: String?, error: NSError?) -> Void) {
        
        /* Build the URL */
        let urlString = Constants.ParseURLSecure + Methods.GetStudentLocations
        let url = NSURL(string: urlString)!
        
        /* Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody : [String:AnyObject] =
            [
                JSONBodyKeys.UniqueKey: user.uniqueKey ?? "",
                JSONBodyKeys.FirstName: user.firstName ?? "",
                JSONBodyKeys.LastName: user.lastName ?? "",
                JSONBodyKeys.MapString: user.mapString ?? "",
                JSONBodyKeys.MediaURL: user.mediaURL ?? "",
                JSONBodyKeys.Latitude: user.latitude ?? 0,
                JSONBodyKeys.Longitude: user.longitude ?? 0
        ]
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
        } catch {
            request.HTTPBody = nil
            print("error")
        }
        
        /* Make the request */
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                
                let userInfo: NSDictionary = [NSLocalizedDescriptionKey: error!.localizedDescription]
                
                let errorObject = NSError(domain: Error.ParseDomainError, code: 1, userInfo: userInfo as [NSObject : AnyObject])
                
                completionHandler(success: false, objectID: nil, error: errorObject)
                
            }
            else {
                /* Parse the data */
                let parsedJSON = (try! NSJSONSerialization.JSONObjectWithData(data!,
                    options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                
                /* Use the data */
                if let objectID = parsedJSON.valueForKey(JSONResponseKeys.ObjectID) as? String {
                    completionHandler(success: true, objectID: objectID, error: nil)
                } else {
                    
                    let userInfo: NSDictionary = [
                        NSLocalizedDescriptionKey: "StudentLocation not created"]
                    
                    let errorObject = NSError(domain: Error.ParseDomainError, code: 2, userInfo: userInfo as [NSObject : AnyObject])
                    
                    completionHandler(success: false, objectID: nil, error: errorObject)
                }
            }
        }
        
        /* Start the request */
        task.resume()
        
    }
    
}