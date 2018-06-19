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
    
    private let baseUrl = "https://turntotech.firebaseio.com/digitalleash"
    
    
    
    private let httpMethodString = "PUT"
    
    let url: URL
    
    lazy var request: URLRequest = {
        var request = URLRequest(url: self.url)
        request.httpMethod = "PUT"
        return request }()

    let config = URLSessionConfiguration.default
    let session = URLSession.shared
    
    init() {
        self.url = URL(string: baseUrl)!
    }
    
    func postWith(username: String, latitude: String, longitude: String, radius: String) {
        
        let json: [String: Any] = ["username": username, "latitude": Double(latitude)!, "longitude": Double(longitude)!, "radius": Double(radius)!]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
        
        let requestUrlString = String (format: "%@/%@.json", baseUrl, username)
        var request = URLRequest(url: URL(string: requestUrlString)!)
        
        request.httpMethod = "PUT"
        
        request.httpBody = jsonData
        
        
        session.dataTask(with: request) { (data, response, error) in
            
            }.resume()
        
    }
    
    
    func patchWith(username: String, latitude: String, longitude: String, radius: String) {
        
        let json: [String: Any] = ["latitude": Double(latitude)!, "longitude": Double(longitude)!, "radius": Double(radius)!]
        // do the same thing for lat, long, radius
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
        
        let requestUrlString = String (format: "%@/%@.json", baseUrl, username)
        var request = URLRequest(url: URL(string: requestUrlString)!)
        
        request.httpMethod = "PATCH"
        
        request.httpBody = jsonData
        
        
        session.dataTask(with: request) { (data, response, error) in
            
            }.resume()
        
    }
    
    func checkStatus(username: String, vc: UIViewController) {
        
        let requestUrlString = String (format: "%@/%@.json", baseUrl, username)
        
        let url = URL(string:requestUrlString)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                
                let current_latitude = json["current_latitude"] as! Double
                let current_longitude = json["current_longitude"] as! Double
                let latitude = json["latitude"] as! Double
                let longitude = json["longitude"] as! Double
                
                
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
            
               
            } catch let error as NSError {
                print(error)
            }
        }).resume()
        
        
    }
    
}

