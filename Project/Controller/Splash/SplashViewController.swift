//
//  SplashViewController.swift
//  Project III
//
//  Created by Be More on 14/03/2021.
//

import UIKit

// MARK: - Properties
class SplashViewController: BaseViewController {
    
    let catImageViewSize: CGFloat = 120
    
    let catImageView = UIImageView(image: UIImage(named: "ic_cat"))

    let splashView = UIView()
    
}

// MARK: - View lifecycles
extension SplashViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.catImageView.contentMode = .scaleAspectFit
        self.catImageView.clipsToBounds = true
        
        self.view.addSubview(self.splashView)
        self.splashView.addSubview(self.catImageView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.splashView.frame = self.view.bounds
        self.catImageView.frame = CGRect(x: self.splashView.frame.midX - catImageViewSize / 2, y: self.splashView.frame.midY - self.catImageViewSize / 2, width: self.catImageViewSize, height: self.catImageViewSize)
        self.catImageView.layer.cornerRadius = self.catImageView.frame.height / 2
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.scaleDownAnimation()
        }
    }
}

// MARK: - Helpers

extension SplashViewController {
    
    private func scaleDownAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.catImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { (success) in
            self.scaleUpAnimation()
        }
    }
    
    private func scaleUpAnimation() {
        let scaleFactor = self.view.frame.width > self.view.frame.height ? self.view.frame.width / self.catImageViewSize : self.view.frame.height / self.catImageViewSize
        UIView.animate(withDuration: 0.35, delay: 0.1, options: .curveEaseIn) {
            self.catImageView.transform = CGAffineTransform(scaleX: scaleFactor * 1.5, y: scaleFactor * 1.5)
            self.catImageView.alpha = 0
        } completion: { (success) in
            self.removeSplashView()
        }
    }
    
    private func removeSplashView() {
        let homeViewController = MainTabBarController()
        self.changeRootViewControllerTo(rootViewController: homeViewController,
                                        withOption: .transitionCrossDissolve,
                                        duration: 0.2)
    }
    
}
