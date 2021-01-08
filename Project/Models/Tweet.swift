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
    var likes: Int
    var comments: Int
    var timestamp: Date!
    let retweets: Int
    var user: User!
    var didLike = false
    var replyingTo: String?
    
    var isReply: Bool {
        return self.replyingTo != nil
    }
    
    init(user: User, tweetId: String, dictionary: [String: Any]) {
        self.tweetId = tweetId
        self.user = user
        
        if let replyingTo = dictionary["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.comments = dictionary["comments"] as? Int ?? 0
        self.retweets = dictionary["retweets"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
    
}
