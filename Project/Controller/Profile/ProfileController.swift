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
    
    private var tweets = [Tweet]() {
        didSet {
            self.collectionView.reloadData()
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
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
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
    }
    
}

// MARK: - UICollectionViewDelegate
extension ProfileController {
    
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
        return self.tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIden, for: indexPath) as? TweetCell else {
            return TweetCell()
        }
        cell.tweet = self.tweets[indexPath.item]
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
