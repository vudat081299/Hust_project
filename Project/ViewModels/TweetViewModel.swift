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
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • MM/dd/yyy"
        return formatter.string(from: self.tweet.timestamp)
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
    
    var retweetsAttributedString: NSAttributedString? {
        return self.attributeText(withValue: self.tweet.retweets, text: "Retweets")
    }
    
    var likessAttributedString: NSAttributedString? {
        return self.attributeText(withValue: self.tweet.likes, text: "Likes")
    }
    
    var usernameText: String {
        return "@\(self.user.username)"
    }
    
    var caption: String {
        return self.tweet.caption
    }
    
    var shouldHideReplyLabel: Bool {
        return !self.tweet.isReply
    }

    var replyText: String? {
        guard let replyingTo = self.tweet.replyingTo else { return nil }
        return "→ replying to @\(replyingTo)"
    }
    
    init(_ tweet: Tweet) {
        self.tweet = tweet
    }
    
    private func attributeText(withValue value: Int, text: String) -> NSAttributedString {
        
        let attributeString = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14),
                                                                                         .foregroundColor: UIColor.black])
        
        attributeString.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                                                   .foregroundColor: UIColor.lightGray]))
        
        return attributeString
    }
    
    var likeButtonTintColor: UIColor {
        return self.tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage? {
        let imageName = self.tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        
        let label = UILabel()
        label.text = self.tweet.caption
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
