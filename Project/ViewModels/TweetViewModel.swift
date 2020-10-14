//
//  TweetViewModel.swift
//  Project
//
//  Created by Be More on 10/15/20.
//

import UIKit

struct TweetViewModel {
    private let tweet: Tweet
    
    private var user: User {
        return tweet.user
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: self.tweet.timestamp, to: now) ?? ""
    }
    
    var profileImageUrl: URL? {
        guard let imageUrl = URL(string: tweet.user.profileImageUrl) else { return nil }
        return imageUrl
    }
    
    var userInfoText: NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self.user.fullName, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        attributeString.append(NSAttributedString(string: " @\(self.user.username.lowercased()) • \(self.timestamp)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return attributeString
    }
    
    var caption: String {
        return self.tweet.caption
    }

    init(_ tweet: Tweet) {
        self.tweet = tweet
    }
}
