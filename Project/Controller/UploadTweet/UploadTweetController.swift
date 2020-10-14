//
//  UploadTweetController.swift
//  Project
//
//  Created by Be More on 10/13/20.
//

import UIKit

class UploadTweetController: BaseViewController {
    
    // MARK: - Properties
    
    private let user: User
    
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
    
    private let captionTextView = CaptionTextView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Selectors
    
    init(user: User) {
        self.user = user
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
        TweetService.shared.upload(caption: caption) { [weak self] error, data in
            guard let `self` = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
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
        
        let stackView = UIStackView(arrangedSubviews: [self.profileImageView, self.captionTextView])
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        self.view.addSubview(stackView)
        
        stackView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                         left: self.view.leftAnchor,
                         right: self.view.rightAnchor,
                         paddingTop: 16,
                         paddingLeft: 16,
                         paddingRight: 16)
        
        guard let url = URL(string: self.user.profileImageUrl) else { return }
        self.profileImageView.sd_setImage(with: url, completed: nil)
    }

}
