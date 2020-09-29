//
//  RegistrationController.swift
//  Project
//
//  Created by Be More on 9/29/20.
//

import UIKit

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributeButton("Already have an account? ", "Log In")
        button.addTarget(self, action: #selector(handleShowLogin(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
  
    // MARK: - Selector
    
    @objc private func handleShowLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.view.backgroundColor = .twitterBlue
        
        self.view.addSubview(self.alreadyHaveAccountButton)
        self.alreadyHaveAccountButton.anchor(left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 40)
        self.alreadyHaveAccountButton.centerX(inView: self.view)
    }
}
