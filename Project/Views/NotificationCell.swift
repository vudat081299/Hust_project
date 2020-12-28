//
//  NotificationCell.swift
//  Project
//
//  Created by Be More on 10/20/20.
//

import UIKit

protocol NotificationCellDelegate: class {
    func didTapProfileImage(_ cell: NotificationCell)
    func didTapFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: NotificationCellDelegate?
    
    var notification: Notification? {
        didSet { self.configure() }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 40, height: 40)
        imageView.layer.cornerRadius = 40 / 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowProfile(_:))))
        return imageView
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test text"
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stackView.spacing = 8
        stackView.alignment = .center
        
        self.contentView.addSubview(stackView)
        stackView.centerY(inView: self.contentView, leftAnchor: self.contentView.leftAnchor, paddingLeft: 12)
        stackView.anchor(right: self.contentView.rightAnchor, paddingRight: 12)
        
        self.contentView.addSubview(self.followButton)
        self.followButton.centerY(inView: self.contentView)
        self.followButton.setDimensions(width: 92, height: 32)
        self.followButton.layer.cornerRadius = 32 / 2
        self.followButton.anchor(right: self.contentView.rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Selectors
    
    @objc private func handleShowProfile(_ sender: UIImageView) {
        self.delegate?.didTapProfileImage(self)
    }
    
    @objc private func handleFollowButtonTapped(_ sender: UIButton) {
        self.delegate?.didTapFollow(self)
    }
    
    // MARK: - Helpers
    
    private func configure() {
        guard let notification = self.notification else { return }
        let viewModel = NotificationViewModel(notification)
        
        self.profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        notificationLabel.attributedText = viewModel.notificationText
        
        self.followButton.isHidden = viewModel.shouldHideFollowButton
        self.followButton.setTitle(viewModel.followButtonText, for: .normal)
    }
}
