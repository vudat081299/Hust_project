//
//  EditProfileHeader.swift
//  Project
//
//  Created by Be More on 10/25/20.
//

import UIKit

protocol EditProfileHeaderDelegate: class {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    
    // MARK: - Properties.
    
    private let user: User
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3.0
        return imageView
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto(_:)), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: EditProfileHeaderDelegate?
    
    // MARK: - Lifecycles.
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        
        self.backgroundColor = .twitterBlue
        
        self.addSubview(self.profileImageView)
        self.profileImageView.center(inView: self, yConstant: -16)
        self.profileImageView.setDimensions(width: 100, height: 100)
        
        self.addSubview(self.changePhotoButton)
        self.changePhotoButton.centerX(inView: self,
                                       topAnchor: self.profileImageView.bottomAnchor,
                                       paddingTop: 8)
        
        guard let imageUrl = URL(string: self.user.profileImageUrl) else {
            return
        }
        self.profileImageView.sd_setImage(with: imageUrl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors.
   
    @objc private func handleChangeProfilePhoto(_ sender: UIButton) {
        self.delegate?.didTapChangeProfilePhoto()
    }
    
    // MARK: - Api.
    
    // MARK: - Helper.
    
}
