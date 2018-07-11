//
//  ViewController.swift
//  ParentChildApp
//
//  Created by Kristina Neuwirth on 4/11/18.
//  Copyright © 2018 Kristina Neuwirth. All rights reserved.
//

import UIKit


final class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var radius: UITextField!
    @IBOutlet weak var noInternetConnection: UILabel!
    
    let networkSend = NetworkSend()

    @IBAction func clickCreate(_ sender: Any) {
        networkSend.postWith(username: username.text!, latitude: latitude.text!, longitude: longitude.text!, radius: radius.text!)
    }
    
    @IBAction func clickUpdate(_ sender: Any) {
        networkSend.patchWith(username: username.text!, latitude: latitude.text!, longitude: longitude.text!, radius: radius.text!)
    }
    
    
    @IBAction func clickStatus(_ sender: Any) {
        networkSend.checkStatus(username: username.text!, vc: self)
    }
                    
}
