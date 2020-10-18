//
//  Tweet.swift
//  Project
//
//  Created by Be More on 10/14/20.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetId: String
    let uid: String
    let likes: Int
    var timestamp: Date!
    let retweets: Int
    var user: User!
    
    init(user: User, tweetId: String, dictionary: [String: Any]) {
        self.tweetId = tweetId
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.uid = dictionary["uid"] as? String ?? ""
        self.retweets = dictionary["retweets"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
    
}
