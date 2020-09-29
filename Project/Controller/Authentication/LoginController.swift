//
//  LoginController.swift
//  Project
//
//  Created by Be More on 9/29/20.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "TwitterLogo")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(image: image, textField: self.emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(image: image, textField: self.passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .white
        button.setTitleColor(.twitterBlue, for: .normal)
        button.layer.cornerRadius =  5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleLogin(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var dontHaveAccountButton: UIButton = {
        let button = Utilities().attributeButton("Don't have an account? ", "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.logoImageView.layer.cornerRadius = self.logoImageView.frame.width / 2
        }
    }
  
    // MARK: - Selector
    
    @objc private func handleLogin(_ sender: UIButton) {
        print("login")
    }
    
    @objc private func handleShowSignUp(_ sender: UIButton) {
        let registrationController = RegistrationController()
        self.navigationController?.pushViewController(registrationController, animated: true)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .twitterBlue
        
        self.view.addSubview(self.logoImageView)
        self.logoImageView.centerX(inView: self.view, topAnchor: self.view.safeAreaLayoutGuide.topAnchor)
        self.logoImageView.setDimensions(width: 150, height: 150)
        
        let stackView = UIStackView(arrangedSubviews: [self.emailContainerView,
                                                       self.passwordContainerView,
                                                       self.loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        self.view.addSubview(stackView)
        stackView.anchor(top: self.logoImageView.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        self.view.addSubview(self.dontHaveAccountButton)
        self.dontHaveAccountButton.anchor(left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 40)
        self.dontHaveAccountButton.centerX(inView: self.view)
    }
}
