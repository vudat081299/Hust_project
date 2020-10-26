//
//  EditProfileViewModel.swift
//  Project
//
//  Created by Be More on 10/25/20.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullName
    case username
    case bio
    
    var discription: String {
        switch self {
        case .fullName:
            return "Name"
        case .username:
            return "Username"
        case .bio:
            return "Bio"
        }
    }
}

struct EditProfileViewModel {
    
    private let user: User
    
    let options: EditProfileOptions
    
    var titleText: String {
        return self.options.discription
    }
    
    var optionValue: String? {
        switch self.options {
        case .fullName: return self.user.fullName
        case .username: return self.user.username
        case .bio: return self.user.bio
        }
    }
    
    var shouldHidePlaceHolder: Bool {
        return self.user.bio != nil
    }
    
    var shouldHideTextField: Bool {
        return self.options == .bio
    }
    
    var shouldHideTextView: Bool {
        return self.options != .bio
    }
    
    init(user: User, options: EditProfileOptions) {
        self.user = user
        self.options = options
    }
}
