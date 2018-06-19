//
//  NetworkConnectivity.swift
//  ChildApp
//
//  Created by Kristina Neuwirth on 5/22/18.
//  Copyright © 2018 Kristina Neuwirth. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
    
       
    
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
        
        } else {
            print("Internet connection FAILED")
            
        }
        
        return ret
            
        }
        
    
}











/* class SCNetworkReachability {
    
    let reachability = SCNetworkReachabilityCreateWithName (nil, "https://turntotech.firebaseio.com/digitalleash/kristina.json")

    do {
        reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
    
        print("ERROR: Unable to create Reachability")
        assumeConnectivity()
    }
}
*/
