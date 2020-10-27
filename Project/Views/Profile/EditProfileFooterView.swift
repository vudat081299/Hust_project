//
//  EditProfileFooterView.swift
//  Project
//
//  Created by Be More on 10/27/20.
//

import UIKit

protocol EditProfileFooterViewDelegate: class {
    func didTapLogout(_ footerView: EditProfileFooterView)
}

class EditProfileFooterView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: EditProfileFooterViewDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogout(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(logoutButton)
        self.logoutButton.anchor(left: self.leftAnchor,
                                 right: self.rightAnchor,
                                 paddingLeft: 16,
                                 paddingRight: 16)
        
        self.logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.logoutButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc private func handleLogout(_ sender: UIButton) {
        self.delegate?.didTapLogout(self)
    }
    
}
