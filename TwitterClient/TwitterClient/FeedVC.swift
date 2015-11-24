//
//  FeedVC.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 20.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    var feedManager = FeedManager()
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBAction func logoutAction(sender: AnyObject) {
        UserManager.logoutUser { (error) -> () in
            if let error = error {
                print(error.localizedDescription)
            }
            NSNotificationCenter.defaultCenter().postNotificationName(ApplicationFlowManager.AppFlowNotifications.UserLoggedOut.rawValue, object: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedManager.loadHomeTimeline()
    }
}