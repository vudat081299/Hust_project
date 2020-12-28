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
    
    func upload(caption: String, type: UploadTweetConfiguration, completion: @escaping Completion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values = ["uid": uid,
                     "timestamp": Int(NSDate().timeIntervalSince1970),
                     "likes": 0,
                     "retweets": 0,
                     "caption": caption] as [String: Any]
        
        switch type {
        case .tweet:
            
            REF_TWEETS.childByAutoId().updateChildValues(values) { (error, ref) in
                guard let tweetId = ref.key else { return }
                REF_USER_TWEETS.child(uid).updateChildValues([tweetId: 1], withCompletionBlock: completion)
            }
            
        case .reply(let tweet):
            
            values["replyingTo"] = tweet.user.username
            
            REF_TWEET_REPLIES.child(tweet.tweetId).childByAutoId().updateChildValues(values) { (err, ref) in
                guard let replyId = ref.key else { return }
                REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetId: replyId], withCompletionBlock: completion)
            }
        }
        
    }
    
    func fetchTweet(completion: @escaping ([Tweet]) -> ()) {
        var tweets = [Tweet]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).observe(.childAdded) { snapshot in
            let followedUid = snapshot.key
            
            REF_USER_TWEETS.child(followedUid).observe(.childAdded) { snapshot in
                let tweetId = snapshot.key
                self.fetchTweet(withTweetId: tweetId) { tweetsData in
                    tweets.append(tweetsData)
                    completion(tweets)
                }
            }
        }
        
        REF_USER_TWEETS.child(currentUid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key
            self.fetchTweet(withTweetId: tweetId) { tweetsData in
                tweets.append(tweetsData)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping ([Tweet]) -> ()) {
        var tweets = [Tweet]()
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { (snapshot) in
            let tweetId = snapshot.key
            
            self.fetchTweet(withTweetId: tweetId) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
            
        }
    }
    
    func fetchTweet(withTweetId tweetId: String, completion: @escaping (Tweet) -> ()) {
        REF_TWEETS.child(tweetId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetId = snapshot.key
            
            UserService.shared.fetchUser(userId: uid) { user in
                guard let user = user else { return }
                let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    func fetchReply(forUser user: User, completion: @escaping ([Tweet]) -> ()) {
        var tweets = [Tweet]()
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetKey = snapshot.key
            guard let replyKey = snapshot.value as? String else { return }
            REF_TWEET_REPLIES.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                let replyId = snapshot.key
                
                UserService.shared.fetchUser(userId: uid) { user in
                    guard let user = user else { return }
                    let tweet = Tweet(user: user, tweetId: replyId, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func fetchReply(forTweet tweet: Tweet, completion: @escaping ([Tweet]) -> () ) {
        var tweets = [Tweet]()
        
        REF_TWEET_REPLIES.child(tweet.tweetId).observe(.childAdded) { snapshot in
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
    
    func fetchLike(forUser user: User, completion: @escaping([Tweet]) -> ()) {
        var tweets = [Tweet]()
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            self.fetchTweet(withTweetId: snapshot.key) { tweet in
                var likedTweet = tweet
                likedTweet.didLike = true
                tweets.append(likedTweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping (Completion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let likes = tweet.didLike ? ((tweet.likes - 1) < 0 ? 0 : (tweet.likes - 1)) : tweet.likes + 1
        REF_TWEETS.child(tweet.tweetId).child("likes").setValue(likes)
        
        if tweet.didLike {
            REF_USER_LIKES.child(uid).child(tweet.tweetId).removeValue { (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetId).removeValue(completionBlock: completion)
            }
        } else {
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetId: 1]) { (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetId).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikeTweet(tweet: Tweet, completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_LIKES.child(uid).child(tweet.tweetId).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func deleteTweet(tweet: Tweet, completion: @escaping Completion) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        REF_TWEETS.child(tweet.tweetId).removeValue { (error, dataReference) in
            REF_USER_TWEETS.child(currentUserId).child(tweet.tweetId).removeValue(completionBlock: completion)
        }
    }
    
}
