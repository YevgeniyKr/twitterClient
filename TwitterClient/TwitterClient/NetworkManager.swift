//
//  NetworkManager.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 27.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation
import ReachabilitySwift

protocol NetworkManagerDelegate: class {
    func connectionEstablished(sender: NetworkManager)
    func connectionLost(sender: NetworkManager)
}

class NetworkManager {
    var reachability: Reachability?
    weak var delegate: NetworkManagerDelegate?

    init() {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            reachability = nil
        }
        if let reachability = reachability {
            reachability.whenReachable = nil
            reachability.whenUnreachable = { reachability in
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.connectionLost(self)
                    self.startWaitingForConnection()
                }
            }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    
    private func startWaitingForConnection() {
        if let reachability = reachability {
            reachability.whenReachable = { reachability in
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.connectionEstablished(self)
                    self.stopWaitingForConnection()
                }
            }
        }
    }
    
    private func stopWaitingForConnection() {
        if let reachability = reachability {
            reachability.whenReachable = nil
        }
    }
    
    class func isNetworkAvailable() -> Bool {
        let reachability: Reachability?
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            reachability = nil
        }
        if let reachability = reachability {
            switch reachability.currentReachabilityStatus {
            case .NotReachable:
                return false
            default:
                return true
            }
        }
        return false
    }
}