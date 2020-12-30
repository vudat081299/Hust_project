//
//  TweetCell.swift
//  Project
//
//  Created by Be More on 10/14/20.
//

import UIKit
import Firebase

protocol TweetCellDelegate: class {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTweet(_ cell: TweetCell)
    func handleDeletePost(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
    
    var needDelete: Bool = false
    
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet {
            configureData()
        }
    }
    
    weak var delegate: TweetCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowProfile(_:))))
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = self.createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleComment(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = self.createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweet(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = self.createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLike(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = self.createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
        return button
    }()
    
    private let replyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private let infoLabel = UILabel()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash", withConfiguration: .none)?.withRenderingMode(.alwaysTemplate).withTintColor(.red), for: .normal)
        button.addTarget(self, action: #selector(handleDelete(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Selectors
    
    @objc private func handleShowProfile(_ sender: UIImageView) {
        self.delegate?.handleProfileImageTapped(self)
    }
    
    @objc private func handleComment(_ sender: UIButton) {
        self.delegate?.handleReplyTapped(self)
    }
    
    @objc private func handleRetweet(_ sender: UIButton) {
        
    }
    
    @objc private func handleLike(_ sender: UIButton) {
        self.delegate?.handleLikeTweet(self)
    }
    
    @objc private func handleShare(_ sender: UIButton) {
        
    }
    
    @objc private func handleDelete(_ sender: UIButton) {
        self.delegate?.handleDeletePost(self)
    }
    // MARK: - Helpers
    
    private func configureUI() {
        
        let captionStackView = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        captionStackView.axis = .vertical
        captionStackView.distribution = .fillProportionally
        captionStackView.spacing = 4
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [self.profileImageView, captionStackView])
        imageCaptionStack.distribution = .fillProportionally
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stackView = UIStackView(arrangedSubviews: [self.replyLabel, imageCaptionStack])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        self.contentView.addSubview(actionStack)
        
        self.contentView.addSubview(stackView)
        self.contentView.addSubview(self.deleteButton)
        
        self.deleteButton.anchor(top: self.contentView.topAnchor,
                                 right: self.contentView.rightAnchor,
                                 paddingTop: 4,
                                 paddingRight: 12)
        self.deleteButton.setDimensions(width: 20, height: 20)
        
        stackView.anchor(top: self.contentView.topAnchor,
                         left: self.contentView.leftAnchor,
                         bottom: actionStack.topAnchor,
                         right: self.deleteButton.leftAnchor,
                         paddingTop: 4,
                         paddingLeft: 12,
                         paddingRight: 12)
        
        
        actionStack.centerX(inView: self.contentView)
        actionStack.anchor(bottom: self.contentView.bottomAnchor, paddingBottom: 8)
        
        let underLineView = UIView()
        underLineView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.contentView.addSubview(underLineView)
        
        underLineView.anchor(left: self.contentView.leftAnchor,
                             bottom: self.contentView.bottomAnchor,
                             right: self.contentView.rightAnchor,
                             height: 1)
        
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    private func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    private func configureData() {
        guard let tweet = self.tweet else { return }
        
        let tweetViewModel = TweetViewModel(tweet)
        
        if self.needDelete && (tweet.user.uid == Auth.auth().currentUser?.uid) {
            self.deleteButton.isHidden = false
        } else {
            self.deleteButton.isHidden = true
        }
        
        self.captionLabel.text = tweetViewModel.caption
    
        self.profileImageView.sd_setImage(with: tweetViewModel.profileImageUrl, completed: nil)
        infoLabel.attributedText = tweetViewModel.userInfoText
        
        self.likeButton.tintColor = tweetViewModel.likeButtonTintColor
        
        self.likeButton.setImage(tweetViewModel.likeButtonImage, for: .normal)
        
        self.replyLabel.text = tweetViewModel.replyText
        
        self.replyLabel.isHidden = tweetViewModel.shouldHideReplyLabel
        
    }
}
