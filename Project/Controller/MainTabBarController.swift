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
        
        let tabBarData: [(UIViewController, UIImage, UIImage)] = [
            (feedsViewController, UIImage(named: "home_unselected")!, UIImage(named: "home_unselected")!.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue)),
            (exploreViewController, UIImage(named: "search_unselected")!, UIImage(named: "search_unselected")!.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue)),
            (notificationsViewController, UIImage(named: "like_unselected")!, UIImage(named: "like_unselected")!.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue)),
            (conversationsViewController, UIImage(named: "ic_mail_outline_white_2x-1")!, UIImage(named: "ic_mail_outline_white_2x-1")!.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue))
        ]
        
        self.viewControllers = tabBarData.map({ (vc, image, selectedImage) -> UINavigationController in
            return self.templateNavigationController(image: image, selectedImage: selectedImage, rootViewController: vc)
        })
    }
    
    /// create navigation bar.
    private func templateNavigationController(image: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
