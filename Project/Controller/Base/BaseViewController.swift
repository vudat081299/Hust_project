//
//  BaseViewController.swift
//  Project
//
//  Created by Be More on 10/3/20.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    // MARK: - Selectors

    @objc private func handleResignFirstResponder() {
        self.view.endEditing(true)
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        self.view.backgroundColor = .white
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleResignFirstResponder)))
    }
}
