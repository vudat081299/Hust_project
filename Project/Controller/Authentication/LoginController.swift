//
//  LoginController.swift
//  Project
//
//  Created by Be More on 9/29/20.
//

import UIKit

class LoginController: BaseViewController {
    
    typealias ViewModelType = LoginViewModel

    // MARK: - Properties
    private var viewModel: ViewModelType!
    
    var moveLogoAnimator: UIViewPropertyAnimator!
    
    private lazy var loginView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var logoImageFrameHoldView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "ic_cat")
        return imageView
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(image: image, textField: self.emailTextField)
        view.alpha = 0
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(image: image, textField: self.passwordTextField)
        view.alpha = 0
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var emailTextField: BindingTextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private lazy var passwordTextField: BindingTextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView()
        act.color = .white
        act.startAnimating()
        act.isHidden = true
        return act
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .twitterBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius =  5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.alpha = 0
        button.addTarget(self, action: #selector(handleLogin(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var dontHaveAccountButton: UIButton = {
        let button = Utilities().attributeButton("Don't have an account? ", "Sign Up")
        button.alpha = 0
        button.addTarget(self, action: #selector(handleShowSignUp(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configure(with: self.viewModel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isUserInteractionEnabled = true
    }
  
    override func viewDidAppear(_ animated: Bool) {
        
        // animation.
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.8, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            self.loginView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (success) in
            self.setUpMoveLogo()
            self.moveLogoAnimator.startAnimation()
        }
    }
    // MARK: - Selector
    
    @objc private func handleLogin(_ sender: UIButton) {
        guard let email = self.viewModel.input.email.value else { return }
        guard let password = self.viewModel.input.password.value else { return }
        
        self.view.isUserInteractionEnabled = false
        self.activityIndicator.isHidden = false
        
        AuthService.shared.login(email: email, password: password) { (result, error) in
            if let error = error {
                self.presentMessage(error.localizedDescription)
                self.view.isUserInteractionEnabled = true
                self.activityIndicator.isHidden = true
                return
            }
            self.gotoHomeController()
        }
    }
    
    func gotoHomeController() {
        let homeController = MainTabBarController()
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.changeRootViewController(view: homeController)
        }
    }
    
    
    @objc private func handleShowSignUp(_ sender: UIButton) {
        let regiterViewModel = RegisterViewModel()
        let registrationController = RegistrationController.create(with: regiterViewModel)
        self.navigationController?.pushViewController(registrationController, animated: true)
    }
    
    // MARK: - Helpers
    
    func configure(with viewModel: ViewModelType) {
        self.emailTextField.bind(callBack: { viewModel.input.email.value = $0 })
        self.passwordTextField.bind(callBack: { viewModel.input.password.value = $0 })
    }
    
    private func configureUI() {
        
        // set up navigation bar
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
        
        // content view contraints
        self.view.addSubview(self.loginView)
        self.loginView.centerX(inView: self.view)
        self.loginView.centerY(inView: self.view, leftAnchor: self.view.leftAnchor, paddingLeft: 32)
        
        
        self.loginView.addSubview(self.logoImageFrameHoldView)
        self.logoImageFrameHoldView.setDimensions(width: 100, height: 100)
        self.logoImageFrameHoldView.centerX(inView: self.loginView, topAnchor: self.loginView.topAnchor, paddingTop: 20)
        
        // stack view.
        let stackView = UIStackView(arrangedSubviews: [self.emailContainerView,
                                                       self.passwordContainerView,
                                                       self.loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        self.loginView.addSubview(stackView)
        stackView.anchor(top: self.logoImageFrameHoldView.bottomAnchor, left: self.loginView.leftAnchor, bottom: self.loginView.bottomAnchor, right: self.loginView.rightAnchor, paddingTop: 20, paddingBottom: 20)
        
        // logo image constaints
        self.loginView.addSubview(self.logoImageView)
        self.logoImageView.setDimensions(width: 100, height: 100)
        self.logoImageView.centerX(inView: self.loginView)
        self.logoImageView.centerY(inView: self.loginView)

        // activity.
        self.loginView.addSubview(self.activityIndicator)
        self.activityIndicator.centerY(inView: self.loginButton)
        self.activityIndicator.anchor(right: self.loginButton.rightAnchor, paddingRight: 10, width: 30, height: 30)
        
        // register button constraints
        self.view.addSubview(self.dontHaveAccountButton)
        self.dontHaveAccountButton.anchor(left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 40)
        self.dontHaveAccountButton.centerX(inView: self.view)
        
        loginView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        self.addInputAccessoryForTextFields(textFields: [self.emailTextField, self.passwordTextField], dismissable: true, previousNextable: true)
    }
    
    // animations.
    private func setUpMoveLogo() {
        self.moveLogoAnimator = UIViewPropertyAnimator(duration: 2, curve: .easeIn, animations: nil)
        self.moveLogoAnimator.addAnimations({
            self.logoImageView.frame.origin.y = 20
        }, delayFactor: 0.2) // delay the start of animation by 0.2 * 2 seconds.
        
        moveLogoAnimator.addAnimations({
            self.emailContainerView.alpha = 1
        }, delayFactor: 0.6) // delay the start of animation by 0.6 * 2 seconds.

        moveLogoAnimator.addAnimations({
            self.passwordContainerView.alpha = 1
        }, delayFactor: 0.7) // delay the start of animation by 0.7 * 2 seconds.
        
        moveLogoAnimator.addAnimations({
            self.loginButton.alpha = 1
            self.dontHaveAccountButton.alpha = 1
        }, delayFactor: 0.8) // delay the start of animation by 0.8 * 2 seconds.
    }
}

extension LoginController {
    static func create(with viewModel: ViewModelType) -> UIViewController {
        let vc = LoginController()
        vc.viewModel = viewModel
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
}
