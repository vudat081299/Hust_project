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
    private func configureViewController() {
        let feedsViewController = FeedsViewController()
        let exploreViewController = ExploreViewController()
        let notificationsViewController = NotificationsViewController()
        let conversationsViewController = ConversationsViewController()
        
        let tabBarData: [(UIViewController, UIImage, UIImage)] = [
            (feedsViewController, UIImage(named: "home_unselected")!, UIImage(named: "home_unselected")!.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue)),
            (exploreViewController, UIImage(named: "home_unselected")!, UIImage(named: "home_unselected")!.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue)),
            (notificationsViewController, UIImage(named: "home_unselected")!, UIImage(named: "home_unselected")!.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue)),
            (conversationsViewController, UIImage(named: "home_unselected")!, UIImage(named: "home_unselected")!.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue))
        ]
        
        self.viewControllers = tabBarData.map({ (vc, image, selectedImage) -> UIViewController in
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.tabBarItem.image = image
            navigationController.tabBarItem.selectedImage = selectedImage
            return navigationController
        })
    }
}
