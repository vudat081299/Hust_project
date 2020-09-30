//
//  Constants.swift
//  Project
//
//  Created by Be More on 9/30/20.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_iamges")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
