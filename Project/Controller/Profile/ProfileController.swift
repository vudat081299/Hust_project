//
//  ProfileController.swift
//  Project
//
//  Created by Be More on 10/15/20.
//

import UIKit

private let cellIden = "TweetCell"
private let collectionHeaderIden = "ProfileHeaderView"

class ProfileController: UICollectionViewController {
    // MARK: - Properties
    
    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var tweets = [Tweet]()
    
    private var likedTweets = [Tweet]()
    
    private var replyTweet = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        switch self.selectedFilter {
        case .tweets:
            return self.tweets
        case .likes:
            return self.likedTweets
        case .replies:
            return self.replyTweet
        }
    }
    
    private var user: User?
    
    // MARK: - Lifecycles
    
    init(_ user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        self.user = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.fetchTweets()
        self.fetchLikeTweets()
        self.fetchReply()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
        self.checkIfUserIsFollowing()
        self.fetchUserStats()
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    private func fetchTweets() {
        guard let user = self.user else { return }
        TweetService.shared.fetchTweets(forUser: user) { [weak self] in
            guard let `self` = self else { return }
            self.tweets = $0;
            self.collectionView.reloadData()
        }
    }
    
    private func fetchLikeTweets() {
        guard let user = self.user else { return }
        TweetService.shared.fetchLike(forUser: user) { [weak self]  in
            guard let `self` = self else { return }
            self.likedTweets = $0
        }
    }
    
    private func fetchReply() {
        guard let user = self.user else { return }
        TweetService.shared.fetchReply(forUser: user) { [weak self] in
            guard let `self` = self else { return }
            self.replyTweet = $0
        }
    }
    
    private func checkIfUserIsFollowing() {
        guard let user = self.user else { return }
        UserService.shared.checkFollowUser(uid: user.uid) { [weak self] isFollowed in
            guard let `self` = self else { return }
            self.user?.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    private func fetchUserStats() {
        guard let user = self.user else { return }
        UserService.shared.fetchUserStats(uid: user.uid) { [weak self] stats in
            guard let `self` = self else { return }
            self.user?.stats = stats
            
            self.collectionView.reloadData()
            
        }
    }
    
    // MARK: - Helpers
    
    private func configureCollectionView() {
        self.collectionView.backgroundColor = .white
        
        self.collectionView.contentInsetAdjustmentBehavior = .never
        
        self.collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellIden)
        self.collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionHeaderIden)
        
        guard let tabBarHeight = self.tabBarController?.tabBar.frame.height else { return }
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight, right: 0)
    }
    
}

// MARK: - UICollectionViewDelegate
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(self.currentDataSource[indexPath.item])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cellHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionHeaderIden, for: indexPath) as? ProfileHeaderView else {
            return ProfileHeaderView()
        }
        
        if let user = self.user {
            cellHeader.user = user
        }
        cellHeader.delegate = self
        
        return cellHeader
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIden, for: indexPath) as? TweetCell else {
            return TweetCell()
        }
        cell.tweet = self.currentDataSource[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 120)
    }
    
}

// MARK: - ProfileHeaderViewDelegate
extension ProfileController: ProfileHeaderViewDelegate {
    
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
    
    func handleEditFollowProfile(_ view: ProfileHeaderView) {
        
        guard let user = self.user else { return }
        
        if user.isCurrentUser {
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (error, ref) in
                self.user?.isFollowed = false
                
                self.collectionView.reloadData()
                
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { (error, ref) in
                self.user?.isFollowed = true
                
                self.collectionView.reloadData()
                NotificationService.shared.uploadNotification(.follow, user: self.user)
            }
        }
        
    }
    
    func profileHeaderView(dissmiss view: ProfileHeaderView) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
