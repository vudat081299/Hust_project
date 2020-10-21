//
//  ProfileHeaderView.swift
//  Project
//
//  Created by Be More on 10/16/20.
//

import UIKit

protocol ProfileHeaderViewDelegate: class {
    func profileHeaderView(dissmiss view: ProfileHeaderView)
    func handleEditFollowProfile(_ view: ProfileHeaderView)
    func didSelect(filter: ProfileFilterOptions)
}

class ProfileHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    var user: User? {
        didSet {
            self.configure()
        }
    }
    
    let filterBar = ProfileFilterView()
    
    private lazy var navigationContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(self.backButton)
        self.backButton.anchor(top:view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.backgroundColor = .lightGray
        imageview.layer.borderWidth = 2
        imageview.layer.borderColor = UIColor.white.cgColor
        return imageview
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.layer.borderWidth = 1.25
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.setTitleColor(.twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(handleEditFollow(_:)), for: .touchUpInside)
        return button
    }()
    
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout"
        label.numberOfLines = 3
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFollowing(_:))))
        return label
    }()
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFollower(_:))))
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.addSubview(self.navigationContainerView)
        self.navigationContainerView.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, height: 108)
        
        self.addSubview(self.profileImageView)
        self.profileImageView.anchor(top: self.navigationContainerView.bottomAnchor, left: self.leftAnchor, paddingTop: -24, paddingLeft: 8)
        self.profileImageView.setDimensions(width: 80, height: 80)
        
        self.addSubview(self.editProfileFollowButton)
        self.editProfileFollowButton.anchor(top: self.navigationContainerView.bottomAnchor,
                                            right: self.rightAnchor,
                                            paddingTop: 12,
                                            paddingRight: 12)
        self.editProfileFollowButton.setDimensions(width: 100,
                                                   height: 36)
        
        let userDetailStack = UIStackView(arrangedSubviews: [self.fullNameLabel, self.userNameLabel, self.bioLabel])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        
        self.addSubview(userDetailStack)
        userDetailStack.anchor(top: self.profileImageView.bottomAnchor,
                               left: self.profileImageView.leftAnchor,
                               right: self.editProfileFollowButton.rightAnchor)
        
        let followStack = UIStackView(arrangedSubviews: [self.followingLabel, self.followerLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        self.addSubview(followStack)
        followStack.anchor(top: userDetailStack.bottomAnchor, left: userDetailStack.leftAnchor, paddingTop: 8)
        
        self.addSubview(filterBar)
        filterBar.delegate = self
        filterBar.anchor(left: self.leftAnchor,
                         bottom: self.bottomAnchor,
                         right: self.rightAnchor,
                         height: 50)
    
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
            self.editProfileFollowButton.layer.cornerRadius = self.editProfileFollowButton.frame.height / 2
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleDismiss(_ sender: UIButton) {
        self.delegate?.profileHeaderView(dissmiss: self)
    }
    
    @objc private func handleEditFollow(_ sender: UIButton) {
        self.delegate?.handleEditFollowProfile(self)
    }
    
    @objc private func handleFollowing(_ sender: UILabel) {
        
    }
    
    @objc private func handleFollower(_ sender: UILabel) {
        
    }
    
    // MARK: - Helpers
    
    private func configure() {
        guard let user = self.user else { return }
        let viewModel = ProfileHeaderViewModel(user)
        
        guard let imageUrl = URL(string: user.profileImageUrl) else { return }
        
        self.profileImageView.sd_setImage(with: imageUrl, completed: nil)
        self.followerLabel.attributedText = viewModel.followerString
        self.followingLabel.attributedText = viewModel.followingString
        self.editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        self.userNameLabel.text = viewModel.userNameText
        self.fullNameLabel.text = viewModel.fullNameText
    }
    
}

// MARK: - ProfileFilterViewDelegate
extension ProfileHeaderView: ProfileFilterViewDelegate {
    func filterView(_ filterView: ProfileFilterView, didSelectItemAt indexPath: IndexPath) {
        guard let filter = ProfileFilterOptions(rawValue: indexPath.item) else { return }
        self.delegate?.didSelect(filter: filter)
    }
}
