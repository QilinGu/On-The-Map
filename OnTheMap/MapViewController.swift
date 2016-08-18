//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Qilin Gu on 8/18/16.
//  Copyright © 2016 SummerTree. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var annotations: [MKPointAnnotation] = [MKPointAnnotation]()
    
    var locationmgr : CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.delegate = self
        
        locationmgr = CLLocationManager()
        locationmgr.requestWhenInUseAuthorization()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.updateMap), name: "userDataUpdated", object: nil)
        
        /* Create and set the logout button */
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MapViewController.logoutButtonTouchUp))
        
        /* Create the set the add pin and reload button */
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "reload-data"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MapViewController.loadData)),
            UIBarButtonItem(image: UIImage(named: "pin-data"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MapViewController.informationPostingButtonTouchUp))
        ]
        
        if (StudentPins.sharedInstance().students.count == 0) {
            
            loadData()
            
        } else {
            
            updateMap()
            
        }
    }
    
    func updateMap() {
        
        self.mapView.removeAnnotations(self.annotations)
        self.generateAnnotations()
        self.mapView.addAnnotations(self.annotations)
        
    }
    
    func generateAnnotations() {
        
        annotations.removeAll(keepCapacity: true)
        
        for user in StudentPins.sharedInstance().students {
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: (user.latitude ?? 0.00), longitude: user.longitude ?? 0.00)
            
            // Create the annotation and set its properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(user.firstName ?? "") \(user.lastName ?? "")"
            annotation.subtitle = user.mediaURL ?? ""
            
            self.annotations.append(annotation)
            
        }
        
    }
    
    func loadData() {
        
        StudentPins.sharedInstance().students.removeAll(keepCapacity: true)
        
        let serialQueue = dispatch_queue_create("com.udacity.onthemap.api", DISPATCH_QUEUE_SERIAL)
        
        let skips = [0, 100]
        for skip in skips {
            dispatch_sync( serialQueue ) {
                
                ParseClient.sharedInstance().getUsers(skip) { users, error in
                    if error == nil {
                        
                        StudentPins.sharedInstance().students.appendContentsOf(users!)
                        
                        if users!.count > 0 {
                            dispatch_async(dispatch_get_main_queue()) {
                                NSNotificationCenter.defaultCenter().postNotificationName("userDataUpdated", object: nil)
                            }
                        }
                        
                        for user in StudentPins.sharedInstance().students {
                            if UdacityClient.sharedInstance().currentUser?.uniqueKey == user.uniqueKey {
                                UdacityClient.sharedInstance().currentUser?.hasPosted = true
                            }
                        }
                        
                    } else {
                        
                        let title: String = error!.localizedDescription
                        let alertController = UIAlertController(title: title, message: error!.localizedDescription, preferredStyle: .Alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
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
    
    func logoutButtonTouchUp() {
        
        UdacityClient.sharedInstance().logout() { (success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .InfoDark)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
        }
    }
    
}

