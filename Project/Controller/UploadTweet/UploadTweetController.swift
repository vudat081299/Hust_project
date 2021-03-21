//
//  UploadTweetController.swift
//  Project
//
//  Created by Be More on 10/13/20.
//

import UIKit
import ActiveLabel

protocol UploadTweetControllerDelegate: class {
    func handleUpdateNumberOfComment(for index: Int)
}

class UploadTweetController: BaseViewController {
    
    // MARK: - Properties
    
    weak var delegate: UploadTweetControllerDelegate?
    
    
    
    
    
    private let user: User
    
    private var index = Int()
    
    private let config: UploadTweetConfiguration
    
    private lazy var viewModel = UploadTweetViewModel(self.config)
    
    private lazy var uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .twitterBlue
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleUpload(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        return imageView
    }()
    
    lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.isUserInteractionEnabled = true
        label.mentionColor = .twitterBlue
        return label
    }()
    
    private let captionTextView = CaptionTextView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.handleMentionTapped()
    }
    
    // MARK: - Selectors
    
    init(config: UploadTweetConfiguration, user: User, delegate: UploadTweetControllerDelegate? = nil, index: Int = 0) {
        self.user = user
        self.config = config
        self.delegate = delegate
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func handleDissmiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleUpload(_ sender: UIButton) {
        guard let caption = self.captionTextView.text else { return }
        
        if caption.isEmpty {
            return
        }
        
        TweetService.shared.upload(caption: caption, type: self.config) { [weak self] error, data in
            guard let `self` = self else { return }
            if error != nil {
                return
            }
            
            if case .reply(let tweet) = self.config {
                self.delegate?.handleUpdateNumberOfComment(for: self.index)
                NotificationService.shared.uploadNotification(.reply, tweet: tweet)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Api
    
    // MARK: - Helpers
    
    override func configureView() {
        super.configureView()
        self.configureUI()
    }
    
    /// set up navigation bar.
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDissmiss(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.uploadButton)
    }
    
    /// set up ui
    private func configureUI() {
        self.configureNavigationBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [self.profileImageView, self.captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.alignment = .leading
        imageCaptionStack.spacing = 12
        
        let stack = UIStackView(arrangedSubviews: [self.replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        self.view.addSubview(stack)
        
        stack.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                     left: self.view.leftAnchor,
                     right: self.view.rightAnchor,
                     paddingTop: 16,
                     paddingLeft: 16,
                     paddingRight: 16)
        
        guard let url = URL(string: self.user.profileImageUrl) else { return }
        self.profileImageView.sd_setImage(with: url, completed: nil)
        
        self.uploadButton.setTitle(self.viewModel.actionButtonText, for: .normal)
        self.captionTextView.placeHolderLabel.text = self.viewModel.placeholderText
        
        self.replyLabel.isHidden = !self.viewModel.shouldShowReplyLabel
        guard let text = self.viewModel.reply else { return }
        self.replyLabel.text = text
    }

    private func handleMentionTapped() {
        self.replyLabel.handleMentionTap { mention in
            print(mention)
        }
    }
}
