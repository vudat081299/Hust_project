//
//  ProfileHeaderViewModel.swift
//  Project
//
//  Created by Be More on 10/17/20.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets:
            return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Like"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    var fullNameText: String {
        return self.user.fullName
    }
    
    var userNameText: String {
        return "@\(self.user.username)"
    }
    
    var followingString: NSAttributedString? {
        return self.attributeText(withValue: self.user.stats?.following ?? 0, text: "Following")
    }
    
    var followerString: NSAttributedString? {
        return self.attributeText(withValue: self.user.stats?.followers ?? 0, text: "Followers")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !self.user.isFollowed && !self.user.isCurrentUser {
            return "Follow"
        }
        
        if self.user.isFollowed {
            return "Following"
        }
        
        return ""
    }
    
    init(_ user: User) {
        self.user = user
    }
    
    func attributeText(withValue value: Int, text: String) -> NSAttributedString {
        
        let attributeString = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14),
                                                                                         .foregroundColor: UIColor.black])
        
        attributeString.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                                                   .foregroundColor: UIColor.lightGray]))
        
        return attributeString
    }
}
