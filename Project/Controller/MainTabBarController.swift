//
//  MainTabBarController.swift
//  Project
//
//  Created by Be More on 9/27/20.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Properties
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
    }
    
    // MARK: - Helpers
    
    /// configure.
    private func configureViewController() {
        let feedsViewController = FeedsViewController()
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
    }
    
    /// create navigation bar.
    private func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
