//
//  NotificationsController.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 10/04/2020.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {

    // MARK: - Properties

    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }

    // MARK: - Selectors

    @objc func handleRefresh() {
        fetchNotifications()
    }

    // MARK: - API

    func fetchNotifications() {
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotifications { (notifications) in
            self.refreshControl?.endRefreshing()
            self.notifications = notifications
            self.checkIfUserIsFollowed()
        }
    }

    func checkIfUserIsFollowed() {
        for (index, notification) in notifications.enumerated() {
            if case .follow = notification.type {
                let user = notification.user

                UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                    self.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }

    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"

        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none

        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

}

// MARK: - UITableViewDataSource

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotificationsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else { return }

        TweetService.shared.fetchTweet(with: tweetID) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - NotificationCellDelegate

extension NotificationsController: NotificationCellDelegate {
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }

        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }

    func didTapFollow(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }

        if user.isFollowed {
            // handle unfollow
            UserService.shared.unfollowUser(uid: user.uid) { (error, red) in
                cell.notification?.user.isFollowed = false
            }
        }
        else {
            // handle follow
            UserService.shared.followUser(uid: user.uid) { (error, red) in
                cell.notification?.user.isFollowed = true
            }
        }
    }
}
