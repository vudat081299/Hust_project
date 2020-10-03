//
//  ConversationsViewController.swift
//  Project
//
//  Created by Be More on 9/27/20.
//

import UIKit

class ConversationsViewController: BaseViewController {

    // MARK: - Properties
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        self.navigationItem.title = "Messages"
    }
}
