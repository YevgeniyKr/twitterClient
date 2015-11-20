//
//  LoginVC.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 20.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import UIKit
import TwitterKit

class LoginVC: UIViewController {
    private let toFeedSegue = "toFeed"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logInButton = TWTRLogInButton { (session, error) in
            if let session = session {
                print("signed in as \(session.userName)");
                self.performSegueWithIdentifier(self.toFeedSegue, sender: self)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)

    }
}
