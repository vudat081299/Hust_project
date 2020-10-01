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
    
    func fetchUser(completion: @escaping (User?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(userId).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { completion(nil); return }
            let user = User(uid: userId, dictionary: dictionary)
            completion(user)
        }
    }
}
