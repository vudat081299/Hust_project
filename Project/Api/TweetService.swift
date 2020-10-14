//
//  TweetService.swift
//  Project
//
//  Created by Be More on 10/14/20.
//

import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct TweetService {
    
    typealias Completion = (Error? ,DatabaseReference) -> Void
    
    static let shared = TweetService()
    
    func upload(caption: String, completion: @escaping Completion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                     "timestamp": Int(NSDate().timeIntervalSince1970),
                     "likes": 0,
                     "retweets": 0,
                     "caption": caption] as [String: Any]
        
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchTweet(completion: @escaping ([Tweet]) -> ()) {
        var tweets = [Tweet]()
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetId = snapshot.key
            
            UserService.shared.fetchUser(userId: uid) { user in
                guard let user = user else { return }
                let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
            
        }
    }
    
}
