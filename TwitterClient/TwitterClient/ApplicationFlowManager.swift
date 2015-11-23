//
//  ApplicationFlowManager.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 24.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import UIKit
import TwitterKit

class ApplicationFlowManager: NSObject {
    
    enum AppFlowNotifications: String {
        case UserLoggedIn = "userLoggedInNotification"
        case UserLoggedOut = "userLoggedOutNotification"
    }
    
    private(set) var window: UIWindow?
    var twitterManager = Twitter.sharedInstance()
    
    private let loginStoryboardName = "Login"
    private let mainStoryboardName = "Main"
    
    convenience init(window: UIWindow) {
        self.init()
        self.window = window
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAuthorizedUserScreen", name: AppFlowNotifications.UserLoggedIn.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLoginScreen", name: AppFlowNotifications.UserLoggedOut.rawValue, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func showAuthorizedUserScreen() {
        if  let vc = UIStoryboard(name: mainStoryboardName, bundle: nil).instantiateInitialViewController(),
            let window = window {
                UIView.transitionWithView(window, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    window.rootViewController = vc
                    }, completion: nil)
        }
    }
    
    func showLoginScreen() {
        if  let vc = UIStoryboard(name: loginStoryboardName, bundle: nil).instantiateInitialViewController(),
            let window = window {
                UIView.transitionWithView(window, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    window.rootViewController = vc
                    }, completion: nil)
        }
    }
    
    
    func applicationDidStart() {
        if let _ = twitterManager.sessionStore.session()?.userID {
            showAuthorizedUserScreen()
        } else {
            showLoginScreen()
        }
    }
}