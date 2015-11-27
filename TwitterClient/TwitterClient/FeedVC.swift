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
    var networkManager = NetworkManager()
    
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
        
        networkManager.delegate = self
        getTimeline()
    }
    
    func prepareTableView() {
        tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("loadNew"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func getTimeline() {
        showBottomLoadingHUD()
        feedManager.getTimeline { (error) -> () in
            self.hideAllHUDs()
            self.tableView.reloadData()
        }
    }
    
    func loadMore() {
        if feedManager.canLoadMore && NetworkManager.isNetworkAvailable(){
            showBottomLoadingHUD()
            feedManager.loadMoreHomeTimeline({ (error) -> () in
                self.hideAllHUDs()
                if error == nil {
                    self.tableView.reloadData()
                }
            })
        }
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

extension FeedVC: NetworkManagerDelegate {
    func connectionEstablished(sender: NetworkManager) {
        showToastMessage(withText: "Connection re-established!")
        getTimeline()
    }
    
    func connectionLost(sender: NetworkManager) {
        showToastMessage(withText: "Connection lost...")
    }
}