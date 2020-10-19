//
//  UserService.swift
//  Project
//
//  Created by Be More on 10/2/20.
//

import Foundation
import Firebase

public typealias DatabaseCompletion = ((Error?, DatabaseReference) -> ())

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
    
    func fetchUser(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping (DatabaseCompletion) ) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUserId).updateChildValues([uid: 1]) { (err, ref) in
            REF_USER_FOLLOWES.child(uid).updateChildValues([currentUserId: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping (DatabaseCompletion) ) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentUserId).child(uid).removeValue { (err, ref) in
            REF_USER_FOLLOWES.child(uid).child(currentUserId).removeValue(completionBlock: completion)
        }
    }
    
    func checkFollowUser(uid: String, completion: @escaping (Bool) -> ()) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentUserId).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping (UserRelationStats) -> ()) {
        REF_USER_FOLLOWES.child(uid).observeSingleEvent(of: .value) { snapshot in
            let follower = snapshot.children.allObjects.count
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                completion(UserRelationStats(followers: follower, following: following))
            }
        }
    }
}
