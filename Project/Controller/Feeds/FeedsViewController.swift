//
//  FeedsViewController.swift
//  Project
//
//  Created by Be More on 9/27/20.
//

import UIKit

class FeedsViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        self.view.backgroundColor = .white
        guard let logoImage = UIImage(named: "cat") else {
            return
        }
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
}
