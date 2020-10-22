//
//  LoginService.swift
//  Project
//
//  Created by Be More on 10/11/20.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

protocol LoginServiceProtocol {
    func login(email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> ())
}

class LoginService: LoginServiceProtocol {
    func login(email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}
