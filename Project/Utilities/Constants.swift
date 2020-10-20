//
//  Constants.swift
//  Project
//
//  Created by Be More on 9/30/20.
//

import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_iamges")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

let REF_TWEETS = DB_REF.child("tweets")

let REF_USER_TWEETS = DB_REF.child("user-tweets")

let REF_USER_FOLLOWES = DB_REF.child("user-followers")

let REF_USER_FOLLOWING = DB_REF.child("user-following")

let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")

let REF_USER_LIKES = DB_REF.child("user-likes")

let REF_TWEET_LIKES = DB_REF.child("tweet-likes")

let REF_NOTIFICATION = DB_REF.child("notifications")
