//
//  RegisterViewModel.swift
//  Project
//
//  Created by Be More on 10/11/20.
//

import Foundation

class RegisterViewModel: ViewModelProtocol {
    
    struct Input {
        let email: Observable<String> = Observable()
        let password: Observable<String> = Observable()
        let fullName: Observable<String> = Observable()
        let userName: Observable<String> = Observable()
    }
    
    // MARK: - Public properties
    let input: Input
    
    init() {
        input = Input()
    }
}
