//
//  ViewController.swift
//  ChildApp
//
//  Created by Kristina Neuwirth on 5/7/18.
//  Copyright © 2018 Kristina Neuwirth. All rights reserved.
//

import UIKit
import CoreLocation


final class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var noInternetConnection: UILabel!
    
    let locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var distanceFromLocation: CLLocationDistance?
    
    var url: URL?
    private let baseUrl = "https://turntotech.firebaseio.com/digitalleash"
    private let httpMethodString = "PATCH"
    
    let config = URLSessionConfiguration.default
    let session = URLSession.shared
    
    lazy var request: URLRequest = {
        var request = URLRequest(url: self.url!)
        request.httpMethod = "PATCH"
        return request
    }()

    @IBAction func reportLocation(_ sender: Any) {
       postWith(username: usernameField.text!)
    
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.url = URL(string: baseUrl)!
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        startLocation = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        startLocation = locations[locations.count - 1]
    }
    
    
    func distance (from fromlocation : CLLocation, to tolocation : CLLocation) -> Double {
        return fromlocation.distance(from:tolocation)
    }
        
   func postWith(username: String) {
        
        let json: [String: Any] = ["username": username,"current_latitude": startLocation.coordinate.latitude, "current_longitude":startLocation.coordinate.longitude]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
        let requestUrlString = String (format: "%@/%@.json", baseUrl, username)
        var request = URLRequest(url: URL(string: requestUrlString)!)
        request.httpMethod = "PATCH"
        request.httpBody = jsonData
        session.dataTask(with: request) { [weak self] (data, response, error) in
            // comes back to this block when post done
            DispatchQueue.main.async {
                self?.performSegue(withIdentifier: "segueshow", sender: nil)
            }
        }.resume()
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            view.backgroundColor = .red
        case .wifi:
            view.backgroundColor = .green
        case .wwan:
            view.backgroundColor = .yellow
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
}
