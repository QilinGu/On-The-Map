//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Qilin Gu on 8/14/16.
//  Copyright © 2016 SummerTree. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewController.updateTable), name: "userDataUpdated", object: nil)
        
        /* Create and set the logout button */
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TableViewController.logoutButtonTouchUp))
        
        /* Create and set the add pin and reload button */
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "reload-data"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TableViewController.loadData)),
            UIBarButtonItem(image: UIImage(named: "pin-data"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TableViewController.informationPostingButtonTouchUp))
        ]
        
        if (StudentPins.sharedInstance().students.count == 0) {
            
            loadData()
            
        } else {
            
            updateTable()
            
        }
        
    }
    
    func updateTable() {
        self.tableView.reloadData()
    }
    
    // MARK: - Table View and Data Source Delegates
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentPins.sharedInstance().students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath)
        let userInformation = StudentPins.sharedInstance().students[indexPath.row]
        
        cell.textLabel?.text = (userInformation.firstName ?? "") + " " + (userInformation.lastName ?? "")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /* show media url in default browser */
        let userInformation = StudentPins.sharedInstance().students[indexPath.row]
        var urlString = userInformation.mediaURL ?? ""
        if !urlString.lowercaseString.hasPrefix("http") {
            urlString = "http://" + urlString
        }
        let link = NSURL(string: urlString)
        //let link = NSURL(string: userInformation.mediaURL ?? "") ?? NSURL(string: "")
        print(link)
        UIApplication.sharedApplication().openURL(link!)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: - Logout
    
    func logoutButtonTouchUp() {
        
        UdacityClient.sharedInstance().logout() { (success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    // MARK: - Navigation Bar Buttons
    
    func loadData() {
        
        StudentPins.sharedInstance().students.removeAll(keepCapacity: true)
        
        let serialQueue = dispatch_queue_create("com.udacity.onthemap.api", DISPATCH_QUEUE_SERIAL)
        
        let skips = [0, 100]
        for skip in skips {
            dispatch_sync( serialQueue ) {
                
                ParseClient.sharedInstance().getUsers(skip) { users, error in
                    if let users = users {
                        StudentPins.sharedInstance().students.appendContentsOf(users)
                        
                        if users.count > 0 {
                            dispatch_async(dispatch_get_main_queue()) {
                                NSNotificationCenter.defaultCenter().postNotificationName("userDataUpdated", object: nil)
                            }
                        }
                        
                    } else {
                        
                        let title: String =  error!.localizedDescription
                        let alertController = UIAlertController(title: title, message: error!.localizedDescription,
                                                                preferredStyle: .Alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        }
                        alertController.addAction(okAction)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    func informationPostingButtonTouchUp() {
        
        if UdacityClient.sharedInstance().currentUser?.hasPosted == true {
            let message = "You have already posted a location. Would you like to overwrite your current location?"
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
            
            let overwriteAction = UIAlertAction(title: "Overwrite", style: .Default) { (action) in
                
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController")
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(overwriteAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController")
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
}