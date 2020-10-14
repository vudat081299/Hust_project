//
//  TweetCell.swift
//  Project
//
//  Created by Be More on 10/14/20.
//

import UIKit

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet {
            configureData()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .twitterBlue
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "test"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleComment(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweet(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLike(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel = UILabel()
    
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
    
    @objc private func handleComment(_ sender: UIButton) {
        
    }
    
    @objc private func handleRetweet(_ sender: UIButton) {
        
    }
    
    @objc private func handleLike(_ sender: UIButton) {
        
    }
    
    @objc private func handleShare(_ sender: UIButton) {
        
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.contentView.addSubview(profileImageView)
        profileImageView.anchor(top: self.contentView.topAnchor,
                                left: self.contentView.leftAnchor,
                                paddingTop: 8,
                                paddingLeft: 8)
        
        let stackView = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        
        self.contentView.addSubview(stackView)
        stackView.anchor(top: self.profileImageView.topAnchor,
                         left: self.profileImageView.rightAnchor,
                         right: self.contentView.rightAnchor,
                         paddingLeft: 12,
                         paddingRight: 12)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        self.contentView.addSubview(actionStack)
        
        actionStack.centerX(inView: self.contentView)
        actionStack.anchor(bottom: self.contentView.bottomAnchor, paddingBottom: 8)
        
        let underLineView = UIView()
        underLineView.backgroundColor = .systemGroupedBackground
        self.contentView.addSubview(underLineView)
        
        underLineView.anchor(left: self.contentView.leftAnchor,
                             bottom: self.contentView.bottomAnchor,
                             right: self.contentView.rightAnchor,
                             height: 1)
        
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.text = "something"
    }
    
    private func configureData() {
        guard let tweet = self.tweet else { return }
        
        let tweetViewModel = TweetViewModel(tweet)
        
        self.captionLabel.text = tweetViewModel.caption
    
        self.profileImageView.sd_setImage(with: tweetViewModel.profileImageUrl, completed: nil)
        infoLabel.attributedText = tweetViewModel.userInfoText
    }
}