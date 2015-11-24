//
//  FeedVC.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 20.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import UIKit
import TwitterKit

class FeedVC: UIViewController {
    var feedManager = FeedManager()
    let tweetTableReuseIdentifier = "TweetCell"
    
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
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
        prepareTableView()
        
        feedManager.getTimeline { (error) -> () in
            self.tableView.reloadData()
        }
    }
    
    func prepareTableView() {
        tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("loadNew"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func loadMore() {
        feedManager.loadMoreHomeTimeline({ (error) -> () in
            self.tableView.reloadData()
        })
    }
    
    func loadNew() {
        feedManager.loadNewTweetsFromTimeline { (error) -> () in
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = feedManager.tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableReuseIdentifier, forIndexPath: indexPath) as! TWTRTweetTableViewCell
        cell.configureWithTweet(tweet)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = feedManager.tweets[indexPath.row]
        return TWTRTweetTableViewCell.heightForTweet(tweet, width: CGRectGetWidth(self.view.bounds))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedManager.tweets.count
    }
}

extension FeedVC: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if feedManager.tweets.count > 0 && scrollView.contentSize.height - scrollView.contentOffset.y < view.bounds.height * 1.5 {
            loadMore()
        }
    }
}