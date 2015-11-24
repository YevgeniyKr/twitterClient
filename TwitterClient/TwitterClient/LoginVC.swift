//
//  LoginVC.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 20.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginAction(sender: AnyObject) {
        UserManager.loginUser { (error) -> () in
            if let error = error {
                print(error.localizedDescription)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(ApplicationFlowManager.AppFlowNotifications.UserLoggedIn.rawValue, object: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
