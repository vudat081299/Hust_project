//
//  MainTabBarController.swift
//  Project
//
//  Created by Be More on 9/27/20.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            guard let nav = self.viewControllers?[0] as? UINavigationController else { return }
            guard let feedsViewController = nav.viewControllers.first as? FeedsViewController else { return }
            feedsViewController.user = user
        }
    }
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.addTarget(self, action: #selector(handleTapActionButton(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
        self.fetchUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.actionButton.layer.cornerRadius = self.actionButton.frame.width / 2
        }
    }
    
    // MARK: - API
    
    private func fetchUser() {
        UserService.shared.fetchUser { user in
            self.user = user
        }
    }
    
    // MARK: - Selector
    
    @objc private func handleTapActionButton(_ sender: UIButton) {
        guard let user = self.user else { return }
        let vc = UploadTweetController(user: user)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.view.addSubview(self.actionButton)
        self.actionButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
    }
    
    /// configure.
    private func configureViewController() {
        let feedsViewController = FeedsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let exploreViewController = ExploreViewController()
        let notificationsViewController = NotificationsViewController()
        let conversationsViewController = ConversationsViewController()
        
        let tabBarData: [(UIViewController, UIImage)] = [
            (feedsViewController, UIImage(named: "home_unselected")!),
            (exploreViewController, UIImage(named: "search_unselected")!),
            (notificationsViewController, UIImage(named: "like_unselected")!),
            (conversationsViewController, UIImage(named: "ic_mail_outline_white_2x-1")!)
        ]
        
        self.viewControllers = tabBarData.map({ (vc, image) -> UINavigationController in
            return self.templateNavigationController(image: image, rootViewController: vc)
        })
        self.configureUI()
    }
    
    /// create navigation bar.
    private func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
