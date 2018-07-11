//
//  Network.swift
//  ParentChildApp
//
//  Created by Kristina Neuwirth on 5/13/18.
//  Copyright © 2018 Kristina Neuwirth. All rights reserved.
//

import CoreLocation
import UIKit

struct NetworkSend {
    
    private static let baseUrl = "https://turntotech.firebaseio.com/digitalleash"
    private static let httpMethodString = "PUT"
    
    let url: URL
    
    lazy var request: URLRequest = {
        var request = URLRequest(url: self.url)
        request.httpMethod = "PUT"
        return request
    }()

    let config = URLSessionConfiguration.default
    let session = URLSession.shared
    
    init() {
        self.url = URL(string: NetworkSend.baseUrl)!
    }
    
    func postWith(username: String, latitude: String, longitude: String, radius: String) {
        
        let json: [String: Any] = ["username": username, "latitude": Double(latitude)!, "longitude": Double(longitude)!, "radius": Double(radius)!]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
        
        let requestUrlString = String (format: "%@/%@.json", NetworkSend.baseUrl, username)
        var request = URLRequest(url: URL(string: requestUrlString)!)
        
        request.httpMethod = "PUT"
        request.httpBody = jsonData
        
        
        session.dataTask(with: request) { (_,_,_) in
            //
        }.resume()
    }
    
    
    func patchWith(username: String, latitude: String, longitude: String, radius: String) {
        
        let json: [String: Any] = ["latitude": Double(latitude) ?? 0.0, "longitude": Double(longitude) ?? 0.0, "radius": Double(radius) ?? 0.0]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
        
        let requestUrlString = String (format: "%@/%@.json", NetworkSend.baseUrl, username)
        var request = URLRequest(url: URL(string: requestUrlString)!)
        request.httpMethod = "PATCH"
        request.httpBody = jsonData
        
        session.dataTask(with: request) { (_, _, _) in
            
        }.resume()
    }
    
    func checkStatus(username: String, vc: UIViewController) {
        
        let requestUrlString = String (format: "%@/%@.json", NetworkSend.baseUrl, username)
        
        let url = URL(string:requestUrlString)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject] else { return }
            
            let current_latitude = json["current_latitude"] as? Double ?? 0.0
            let current_longitude = json["current_longitude"] as? Double ?? 0.0
            let latitude = json["latitude"] as? Double ?? 0.0
            let longitude = json["longitude"] as? Double ?? 0.0
            
            let current_loc = CLLocation(latitude: current_latitude, longitude: current_longitude)
            let parent_loc = CLLocation(latitude: (latitude), longitude: (longitude))
            
            let distanceInMeters = current_loc.distance(from: parent_loc)
            
            print(distanceInMeters)
            
            let radius = json["radius"] as! Double
            
            
            if distanceInMeters <= radius {
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    print("Child is ok.")
                    vc.performSegue(withIdentifier: "SegueOK", sender: nil)
                    
                })
                
                
            } else {
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    print("Child is NOT ok.")
                    vc.performSegue(withIdentifier: "SegueNotOK", sender: nil)
                    
                })
                
            }
        }).resume()
        
        
    }
    
}

