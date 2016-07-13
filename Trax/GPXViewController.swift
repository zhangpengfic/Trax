//
//  GPXViewController.swift
//  Trax
//
//  Created by Alfred on 16/7/13.
//  Copyright © 2016年 WanXunAlfred. All rights reserved.
//

import UIKit
import MapKit

class GPXViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Standard
            mapView.delegate = self
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate
        
        center.addObserverForName(GPXURL.Notification, object: appDelegate, queue: queue) { notification in
            if let url = notification.userInfo?[GPXURL.Key] as? NSURL {
//                self.gpxURL = url
                print(url)
            }
        }
        
//        gpxURL = NSURL(string: "http://cs193p.stanford.edu/Vacation.gpx")
    }


}
