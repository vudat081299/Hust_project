//
//  TweetController.swift
//  Project
//
//  Created by Be More on 10/17/20.
//

import UIKit

private let headerIden = "TweetHeader"
private let cellIden = "TweetCell"

class TweetController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var tweet: Tweet
    private var replies = [Tweet]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var actionSheetLaucher: ActionSheetLaucher
    
    // MARK: - Lifecycles
    
    init(_ tweet: Tweet) {
        self.tweet = tweet
        self.actionSheetLaucher = ActionSheetLaucher(tweet.user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
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
        
        self.collectionView.backgroundColor = .white
        
        self.collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellIden)
        
        self.collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIden)
        
    }
    
}

// MARK: - UICollectionViewDelegate
extension TweetController {
    
}

// MARK: - UICollectionViewDataSource
extension TweetController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIden, for: indexPath) as? TweetHeader else {
            return TweetHeader()
        }
        headerCell.tweet = self.tweet
        headerCell.delegate = self
        return headerCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIden, for: indexPath) as? TweetCell else {
            return UICollectionViewCell()
        }
        
        cell.tweet = self.replies[indexPath.row]
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TweetController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
        let viewModel = TweetViewModel(tweet)
        let height = viewModel.size(forWidth: self.collectionView.frame.width).height
        return CGSize(width: self.collectionView.frame.width, height: height + 260)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 120)
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
