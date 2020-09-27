//
//  NotificationsViewController.swift
//  Project
//
//  Created by Be More on 9/27/20.
//

import UIKit

class NotificationsViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Notifications"
    }

}
