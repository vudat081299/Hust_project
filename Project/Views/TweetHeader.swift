//
//  TweetHeader.swift
//  Project
//
//  Created by Be More on 10/17/20.
//

import UIKit

protocol TweetHeaderDelegate: class {
    func showActionSheet(_ view: TweetHeader)
}

class TweetHeader: UIView {
    
    // MARK: - Properties
    
    weak var delegate: TweetHeaderDelegate?
    
    var tweet: Tweet? {
        didSet {
            self.configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .twitterBlue
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowProfile(_:))))
        return imageView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Full Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Username"
        label.textColor = .lightGray
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "6 : 33 PM - 11/04/1999"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var retweetsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "2 retweets"
        return label
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "2 likes"
        return label
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(#imageLiteral(resourceName: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(handleShowActionSheet(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor,
                        paddingLeft: 8,
                        height: 1)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left: divider1.leftAnchor,
                        bottom: view.bottomAnchor,
                        right: view.rightAnchor,
                        height: 1)
        
        return view
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
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.profileImageView)
        
        let labelStack = UIStackView(arrangedSubviews: [self.fullNameLabel, self.userNameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let imageCaption = UIStackView(arrangedSubviews: [self.profileImageView, labelStack])
        imageCaption.axis = .horizontal
        imageCaption.spacing = 12
        
        let stack = UIStackView(arrangedSubviews: [self.replyLabel, imageCaption])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        self.addSubview(self.captionLabel)
        self.captionLabel.anchor(top: stack.bottomAnchor,
                                 left: self.leftAnchor,
                                 right: self.rightAnchor,
                                 paddingTop: 12,
                                 paddingLeft: 16,
                                 paddingRight: 16)
        
        self.addSubview(self.dateLabel)
        self.dateLabel.anchor(top: self.captionLabel.bottomAnchor,
                              left: self.captionLabel.leftAnchor,
                              paddingTop: 12)
        
        self.addSubview(self.optionButton)
        self.optionButton.centerY(inView: stack)
        self.optionButton.anchor(right: self.rightAnchor,
                                 paddingRight: 8)
        
        self.addSubview(self.statsView)
        self.statsView.anchor(top: self.dateLabel.bottomAnchor,
                              left: self.leftAnchor,
                              right: self.rightAnchor,
                              paddingTop: 12,
                              height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        actionStack.distribution = .fillEqually
        
        self.addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(top: statsView.bottomAnchor, bottom: self.bottomAnchor, paddingTop: 12)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Selectors
    
    @objc private func handleShowProfile(_ sender: UIImageView) {
       
    }
    
    @objc private func handleShowActionSheet(_ sender: UIButton) {
        self.delegate?.showActionSheet(self)
    }
    
    @objc private func handleComment(_ sender: UIButton) {
        
    }
    
    @objc private func handleRetweet(_ sender: UIButton) {
        
    }
    
    @objc private func handleLike(_ sender: UIButton) {
        
    }
    
    @objc private func handleShare(_ sender: UIButton) {
        
    }
    
    // MARK: - Helpers
    
    private func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    private func configure() {
        guard let tweet = self.tweet else { return }
        let viewModel = TweetViewModel(tweet)
        
        self.captionLabel.text = viewModel.caption
        self.userNameLabel.text = viewModel.usernameText
        self.fullNameLabel.text = tweet.user.fullName
        
        guard let imageUrl = URL(string: tweet.user.profileImageUrl) else { return }
        self.profileImageView.sd_setImage(with: imageUrl, completed: nil)
        
        self.dateLabel.text = viewModel.headerTimestamp
        
        self.retweetsLabel.attributedText = viewModel.retweetsAttributedString
        self.likesLabel.attributedText = viewModel.likessAttributedString
        
        self.likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        self.likeButton.tintColor = viewModel.likeButtonTintColor
        
        self.replyLabel.isHidden = viewModel.shouldHideReplyLabel
        self.replyLabel.text = viewModel.replyText
    }
    
}
