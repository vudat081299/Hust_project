//
//  UserService.swift
//  Project
//
//  Created by Be More on 10/2/20.
//

import Foundation
import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(userId: String? = nil, completion: @escaping (User?) -> Void) {
        var uid: String
        if userId != nil {
            uid = userId!
        } else {
            guard let uidAuth = Auth.auth().currentUser?.uid else { return }
            uid = uidAuth
        }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { completion(nil); return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}
