//
//  UploadTweetViewModel.swift
//  Project
//
//  Created by Be More on 10/18/20.
//

import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}


struct UploadTweetViewModel {
    let actionButtonText: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var reply: String?
    
    init(_ config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            self.actionButtonText = "Tweet"
            self.placeholderText = "What's happening"
            self.shouldShowReplyLabel = false
        case .reply(let tweet):
            self.actionButtonText = "Reply"
            self.placeholderText = "Tweet your reply"
            self.shouldShowReplyLabel = true
            self.reply = "reply to @\(tweet.user.username)"
        }
    }
}
