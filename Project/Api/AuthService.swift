//
//  AuthService.swift
//  Project
//
//  Created by Be More on 9/30/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct AuthCredentials {
    let email: String
    let password: String
    let username: String
    let fullName: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func login(email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storagre = STORAGE_PROFILE_IMAGES.child(fileName)
        storagre.putData(imageData, metadata: nil) { (metaData, error) in
            storagre.downloadURL { (url, error) in
                
                guard let imageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    
                    if let error = error {
                        print("[DEBUG] error: \(error.localizedDescription)")
                        completion(error, DatabaseReference())
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email": credentials.email,
                                  "username": credentials.username,
                                  "fullName": credentials.fullName,
                                  "profileImageUrl": imageUrl]
                    
                    // save user data into realtime database.
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
    
}
