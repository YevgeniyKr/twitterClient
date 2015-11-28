//
//  ComposeTweetVC.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 28.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation

class ComposeTweetVC: UIViewController {
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sendTweetButton: UIBarButtonItem!
    
    @IBAction func sendTweetAction(sender: AnyObject) {
        FeedManager.postTweet(withText: inputTextView.text) { (shouldSendLater, error) -> () in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if shouldSendLater {
                    self.performSegueWithIdentifier(self.toFeedWithDelayedTweetUnwindSegue, sender: self)
                } else {
                    self.performSegueWithIdentifier(self.toFeedUnwindSegue, sender: self)
                }
            }
        }
    }
    
    var notificationCenter = NSNotificationCenter.defaultCenter()
    private let toFeedUnwindSegue = "unwindWithSuccessfullySendedTweet"
    private let toFeedWithDelayedTweetUnwindSegue = "unwindWithDelayedTweet"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        textViewBottomConstraint.constant = 0.0
        if let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            textViewBottomConstraint.constant = keyboardSize.size.height
            if let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}

extension ComposeTweetVC: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let characterLimit = 140

        if textView.text.characters.count + (text.characters.count - range.length) > characterLimit {
            var newText = textView.text as NSString
            newText = newText.stringByReplacingCharactersInRange(range, withString: text)
            if newText.length > characterLimit {
                newText = newText.substringToIndex(characterLimit - 1)
                textView.text = newText as String
            }
            return false
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.characters.count > 0 {
            sendTweetButton.enabled = true
        } else {
            sendTweetButton.enabled = false
        }
    }
}