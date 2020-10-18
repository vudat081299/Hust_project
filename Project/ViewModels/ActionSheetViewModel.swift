//
//  ActionSheetViewModel.swift
//  Project
//
//  Created by Be More on 10/18/20.
//

import UIKit

struct ActionSheetViewModel {
    
    private var user: User
    
    var option: [ActionSheetOption] {
        var result = [ActionSheetOption]()
        
        if user.isCurrentUser {
            result.append(.delete)
        } else {
            let followOption: ActionSheetOption = user.isFollowed ? .unfollow(self.user) : .follow(self.user)
            result.append(followOption)
        }
        result.append(.report)
        return result
    }
    
    init(_ user: User) {
        self.user = user
    }
}

enum ActionSheetOption {

    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unfollow(let user):
            return "Unfollow @\(user.username)"
        case .report:
            return "Report Tweet"
        case .delete:
            return "Delete Tweet"
        }
    }
    
}
