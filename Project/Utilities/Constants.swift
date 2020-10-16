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
