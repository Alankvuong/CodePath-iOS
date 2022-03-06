//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Alan Vuong on 2/25/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()       // making an array to store tweets
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets();
    }
    
    @objc func loadTweets() {
        numberOfTweets = 20
        let resourceUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numberOfTweets];
        
        TwitterAPICaller.client?.getDictionariesRequest(url: resourceUrl, parameters: params as [String: Any], success:
            { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll();        // Removes all old tweets from array
            for tweet in tweets {
                self.tweetArray.append(tweet);
            }
            
            print("Loading new tweets")
            self.tableView.reloadData();
            self.myRefreshControl.endRefreshing();
            
        }, failure: { (Error) in
            print(Error.localizedDescription);
            print("Could not retreive tweets.");
            self.myRefreshControl.endRefreshing();
        })
    }

    
    func loadMoreTweets() {
        let resourceUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets += 20
        
        let params = ["count": numberOfTweets];
        
        TwitterAPICaller.client?.getDictionariesRequest(url: resourceUrl, parameters: params as [String : Any], success:
            { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll();        // Removes all old tweets from array
            for tweet in tweets {
                self.tweetArray.append(tweet);
            }
            
            self.tableView.reloadData();
            self.myRefreshControl.endRefreshing();
            
        }, failure: { (Error) in
            print(Error.localizedDescription);
            print("Could not retreive tweets.");
            self.myRefreshControl.endRefreshing();
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout();
        self.dismiss(animated: true, completion: nil)
        print("Logged out");
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String

        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
         if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }

        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return tweetArray.count;
    }

}
