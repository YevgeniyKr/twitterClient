//
//  UserManager.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 24.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation
import TwitterKit

class UserManager {
    
    class func loginUser(completion: (error: NSError?)->()) {
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if let session = session {
                print("signed in as \(session.userName)")
                completion(error: nil)
            } else {
                completion(error: error)
            }
            
        }
    }
    
    class func logoutUser(completion: (error: NSError?)->()) {
        let store = Twitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
            completion(error: nil)
        } else {
            completion(error: NSError.errorWithLocalizedDescription(NSLocalizedString("NoUserError", comment: "")))
        }
    }
}