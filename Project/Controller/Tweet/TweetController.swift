//
//  TweetController.swift
//  Project
//
//  Created by Be More on 10/17/20.
//

import UIKit

private let headerIden = "TweetHeader"
private let cellIden = "TweetCell"

class TweetController: BaseViewController {
    
    // MARK: - Properties
    
    private var tweet: Tweet

    private var collectionViewHeightAnchor: NSLayoutConstraint?
    
    private var replies = [Tweet]() {
        didSet {
            self.collectionView.reloadData()
            let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewHeightAnchor?.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    private var actionSheetLaucher: ActionSheetLaucher
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var tweetHeaderView: TweetHeader = {
        let view = TweetHeader()
        view.isUserInteractionEnabled = true
        view.tweet = self.tweet
        view.delegate = self
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collecionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collecionView.backgroundColor = .white
        collecionView.delegate = self
        collecionView.dataSource = self
        collecionView.backgroundColor = .white
        return collecionView
    }()
    
    // MARK: - Lifecycles
    
    init(_ tweet: Tweet) {
        self.tweet = tweet
        self.actionSheetLaucher = ActionSheetLaucher(tweet.user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureController()
        self.fetchReplies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    private func fetchReplies() {
        TweetService.shared.fetchReply(forTweet: self.tweet) { replies in
            self.replies = replies
        }
    }
    
    // MARK: - Helpers
    
    private func configureController() {
        
        self.title = "Tweet"
        
        self.view.addSubview(self.scrollView)
       
        self.scrollView.anchor(top: self.view.topAnchor,
                               left: self.view.leftAnchor,
                               bottom: self.view.bottomAnchor,
                               right: self.view.rightAnchor)
    
        self.scrollView.addSubview(self.tweetHeaderView)
        self.tweetHeaderView.anchor(top: self.scrollView.topAnchor,
                                    left: self.scrollView.leftAnchor,
                                    right: self.scrollView.rightAnchor)
        self.tweetHeaderView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        self.scrollView.addSubview(self.collectionView)
        self.collectionView.anchor(top: self.tweetHeaderView.bottomAnchor,
                                   left: self.scrollView.leftAnchor,
                                   bottom: self.scrollView.bottomAnchor,
                                   right: self.scrollView.rightAnchor)
        
        self.collectionViewHeightAnchor = self.collectionView.heightAnchor.constraint(equalToConstant: 0)
        self.collectionViewHeightAnchor?.priority = .required - 1
        self.collectionViewHeightAnchor?.isActive = true
        
        self.collectionView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true

        self.collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellIden)
            
    }
    
}

// MARK: - UICollectionViewDelegate
extension TweetController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension TweetController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.replies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIden, for: indexPath) as? TweetCell else {
            return UICollectionViewCell()
        }
        
        cell.tweet = self.replies[indexPath.row]
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TweetController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = self.replies[indexPath.item]
        let viewModel = TweetViewModel(tweet)
        let height = viewModel.size(forWidth: self.collectionView.frame.width).height
        return CGSize(width: self.collectionView.frame.width, height: height + 72)
    }
    
}

// MARK: - TweetHeaderDelegate

extension TweetController: TweetHeaderDelegate {
    func showActionSheet(_ view: TweetHeader) {
        if self.tweet.user.isCurrentUser {
            self.actionSheetLaucher = ActionSheetLaucher(self.tweet.user)
            self.actionSheetLaucher.delegate = self
            self.actionSheetLaucher.show()
        } else {
            UserService.shared.checkFollowUser(uid: self.tweet.user.uid) { isFollowed in
                let tweetUser = self.tweet.user
                guard var user = tweetUser else {return}
                user.isFollowed = isFollowed
                self.actionSheetLaucher = ActionSheetLaucher(user)
                self.actionSheetLaucher.delegate = self
                self.actionSheetLaucher.show()
            }
        }
    }
}

// MARK: - ActionSheetLaucherDelegate

extension TweetController: ActionSheetLaucherDelegate {
    func didSelect(option: ActionSheetOption) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { err, ref in
                
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { err, ref in
                
            }
        case .report:
            break
        case .delete:
            break
        }
    }
}
