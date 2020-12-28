//
//  NotificationsViewController.swift
//  Project
//
//  Created by Be More on 9/27/20.
//

import UIKit

private let cellIden = "NotificationCell"

class NotificationsViewController: UITableViewController {

    // MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet {
            self.tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
        self.fetNotification()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        
    }
    
    // MARK: - Api
    
    private func fetNotification() {
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotification(completion: { [weak self]  in
            guard let `self` = self else { return }
            self.notifications = $0.sorted {
                $0.timestamp > $1.timestamp
            }
            self.checkIfUserIsFollowed(notifications: $0)
        })
    }
    
    private func checkIfUserIsFollowed(notifications: [Notification]) {
        
        guard !notifications.isEmpty else { return }
        
        notifications.forEach { notification in
            guard case .follow = notification.type else { return }
            
            let user = notification.user
            UserService.shared.checkFollowUser(uid: user.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.user.uid == notification.user.uid }) {
                    self.notifications[index].user.isFollowed = true
                }
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        self.fetNotification()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        self.navigationItem.title = "Notifications"
        self.tableView.backgroundColor = .white
        self.tableView.rowHeight = 60
        self.tableView.separatorStyle = .none
        self.tableView.register(NotificationCell.self, forCellReuseIdentifier: cellIden)
        
        let refreshControl = UIRefreshControl()
        self.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
    }

}

// MARK: - UITableViewDelegate

extension NotificationsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = self.notifications[indexPath.row]
        guard let tweetId = notification.tweetId else { return }
        TweetService.shared.fetchTweet(withTweetId: tweetId) { tweet in
            let tweetController = TweetController(tweet)
            self.navigationController?.pushViewController(tweetController, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension NotificationsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIden, for: indexPath) as? NotificationCell else {
            return NotificationCell()
        }
        cell.notification = self.notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - NotificationCellDelegate


extension NotificationsViewController: NotificationCellDelegate {
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        let profileController = ProfileController(user)
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    func didTapFollow(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { err, ref in
                cell.notification?.user.isFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { err, ref in
                cell.notification?.user.isFollowed = true
            }
        }
    }

}
