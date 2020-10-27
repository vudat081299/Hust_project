//
//  NotificationService.swift
//  Project
//
//  Created by Be More on 10/20/20.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(_ type: NotificationType,
                            tweet: Tweet? = nil,
                            user: User? = nil) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var values = ["timestamp": Int(NSDate().timeIntervalSince1970),
                      "uid":uid,
                      "type":type.rawValue] as [String : Any]
        
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetId
            REF_NOTIFICATION.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else if let user = user {
            REF_NOTIFICATION.child(user.uid).childByAutoId().updateChildValues(values)
        }
        
    }
    
    func fetchNotification(completion: @escaping([Notification]) -> ()) {
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_NOTIFICATION.child(uid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                completion(notifications)
            } else {
                REF_NOTIFICATION.child(uid).observe(.childAdded) { snapshot in
                    guard let dictionary = snapshot.value as? [String: Any] else { return }
                    guard let uid = dictionary["uid"] as? String else { return }
                    
                    UserService.shared.fetchUser(userId: uid) { user in
                        guard let user = user else { return }
                        let notification = Notification(user: user, dictionary: dictionary)
                        notifications.append(notification)
                        completion(notifications)
                    }
                }
            }
        }
    }
}
