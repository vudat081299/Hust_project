//
//  NotificationViewModel.swift
//  Project
//
//  Created by Be More on 10/21/20.
//

import UIKit

struct NotificationViewModel {
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: self.notification.timestamp, to: now) ?? ""
    }
    
    var notificationString: String {
        switch type {
        case .follow:
            return " stated following you"
        case .like:
            return " liked your tweet"
        case .reply:
            return " reply to your tweet"
        case .retweet:
            return " retweeted your tweet"
        case .mention:
            return "mentioned you in your tweet"
        }
    }
    
    var notificationText: NSAttributedString? {
        let attributeString = NSMutableAttributedString(string: user.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 12),
                                                                                            .foregroundColor: UIColor.black])
        
        attributeString.append(NSAttributedString(string: self.notificationString, attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                                                                .foregroundColor: UIColor.black]
        ))
        
        attributeString.append(NSAttributedString(string: " \(self.timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                                                             .foregroundColor: UIColor.lightGray]))
        
        return attributeString
    }
    
    var profileImageUrl: URL? {
        guard let iamgeUrl = URL(string: self.user.profileImageUrl) else { return nil }
        return iamgeUrl
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String {
        return self.user.isFollowed ? "Following" : "Follow"
    }
    
    init (_ notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
