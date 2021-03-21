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
    
    func configureView() {
        self.view.backgroundColor = .white
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleResignFirstResponder)))
    }
    
    func changeRootViewControllerTo(rootViewController: UIViewController, withOption options: UIView.AnimationOptions = .curveLinear, duration: TimeInterval = 0) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }
    
        sceneDelegate.window?.rootViewController = rootViewController
        
        UIView.transition(with: sceneDelegate.window!,
                          duration: duration,
                          options: options,
                          animations: {},
                          completion:{ completed in })
    }
}
