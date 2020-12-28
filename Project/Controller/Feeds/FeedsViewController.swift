//
//  FeedsViewController.swift
//  Project
//
//  Created by Be More on 9/27/20.
//

import UIKit
import SDWebImage

private let cellIden = "TweetCell"

class FeedsViewController: UICollectionViewController {

    // MARK: - Properties
    
    private var tweets = [Tweet]() {
        didSet {
            self.collectionView.refreshControl?.endRefreshing()
            if self.collectionView.refreshControl == nil {
                let refreshControl = UIRefreshControl()
                refreshControl.addTarget(self, action: #selector(hanldeRefresh(_:)), for: .valueChanged)
                self.collectionView.refreshControl = refreshControl
            }
        }
    }
    
    var user: User? {
        didSet {
            self.configureLeftBarButton()
        }
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
        self.fetchTweet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    
    // MARK: - Selectors
    
    @objc private func hanldeRefresh(_ sender: UIRefreshControl) {
        self.fetchTweet()
    }
    
    @objc private func handleGoToProfile(_ sender: UIImageView) {
        guard let user = self.user else { return }
        let profileController = ProfileController(user)
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    // MARK: -  Api
    
    private func fetchTweet() {
        self.collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchTweet { [weak self] tweets in
            guard let `self` = self else { return }
            self.tweets = tweets.sorted { $0.timestamp > $1.timestamp }
            self.checkIfUserLikeTweet()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func checkIfUserLikeTweet() {
        self.tweets.forEach { tweet in
            TweetService.shared.checkIfUserLikeTweet(tweet: tweet) { didLike in
                guard didLike == true else { return }
                if let index = self.tweets.firstIndex(where: { $0.tweetId == tweet.tweetId }) {
                    self.tweets[index].didLike = true
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func configureViewController() {
        
        self.collectionView.backgroundColor = .white
        
        guard let logoImage = UIImage(named: "cat") else {
            return
        }
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        self.navigationItem.titleView = imageView
        
        self.collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellIden)
    }
    
    private func configureLeftBarButton() {
        guard let user = self.user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGoToProfile(_:))))
        
        guard let imageUrl = URL(string: user.profileImageUrl) else { return }
        
        profileImageView.sd_setImage(with: imageUrl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

// MARK: - UICollectionViewDelegate
extension FeedsViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(self.tweets[indexPath.item])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension FeedsViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIden, for: indexPath) as? TweetCell else { return TweetCell() }
        cell.tweet = self.tweets[indexPath.item]
        cell.needDelete = true
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = self.tweets[indexPath.item]
        let viewModel = TweetViewModel(tweet)
        let height = viewModel.size(forWidth: self.collectionView.frame.width).height
        return CGSize(width: self.collectionView.frame.width, height: height + 72)
    }
}

// MARK: - TweetCellDelegate
extension FeedsViewController: TweetCellDelegate {
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let uploadTweetController = UploadTweetController(config: .reply(tweet), user: tweet.user)
        let nav = UINavigationController(rootViewController: uploadTweetController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func handleLikeTweet(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        guard let index = self.collectionView.indexPath(for: cell) else { return }
        TweetService.shared.likeTweet(tweet: tweet) { (err, ref) in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? ((tweet.likes - 1) < 0 ? 0 : (tweet.likes - 1)) : tweet.likes + 1
            cell.tweet?.likes = likes
            
            self.tweets[index.item].likes = likes
            self.tweets[index.item].didLike = !tweet.didLike
            
            // only upload notification when user like
            guard !tweet.didLike else { return }
            NotificationService.shared.uploadNotification(.like, tweet: tweet)
        }
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let profileComtroller = ProfileController(user)
        self.navigationController?.pushViewController(profileComtroller, animated: true)
    }
    
    func handleDeletePost(_ cell: TweetCell) {
    
        self.presentMessage("Do you want to delete this post?") { action in
            guard let tweet = cell.tweet else { return }
            TweetService.shared.deleteTweet(tweet: tweet) { [weak self] (error, ref) in
                guard let `self` = self else { return }
                self.tweets.remove(at: self.collectionView.indexPath(for: cell)!.item)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
}
