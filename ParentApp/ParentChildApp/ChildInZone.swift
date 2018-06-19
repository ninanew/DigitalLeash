//
//  ChildInZone.swift
//  ParentChildApp
//
//  Created by Kristina Neuwirth on 5/8/18.
//  Copyright © 2018 Kristina Neuwirth. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class ChildInZone: UIViewController {
    
    struct childInZone {
        
    let locationManager = CLLocationManager()
     
        func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
            // Make sure the app is authorized.
            if CLLocationManager.authorizationStatus() == .authorizedAlways {
                // Make sure region monitoring is supported.
                if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                    // Register the region.
                    let maxDistance = locationManager.maximumRegionMonitoringDistance
                    let region = CLCircularRegion(center: center,
                                                  radius: maxDistance, identifier: identifier)
                    
                    
                    region.notifyOnEntry = true
                    region.notifyOnExit = false
                    
                    
                    locationManager.startMonitoring(for: region)
                
                }
                
            }
            
        }
    }
        override func viewDidLoad() {
        super.viewDidLoad()
    }
}

