//
//  ProfileController.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 13/04/2020.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var user: User

    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet { collectionView.reloadData() }
    }
    
    private var tweets = [Tweet]()
    private var replies = [Tweet]()
    private var likedTweets = [Tweet]()

    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets: return tweets
        case .replies: return replies
        case .likes: return likedTweets
        }
    }
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        checkIfUserIsFollowed()
        fetchUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - API
    
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = currentDataSource[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        selectedFilter = filter
    }

    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        if user.isCurrentUser {
            return
        }
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (database, error) in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { (database, error) in
                self.user.isFollowed = true
                self.collectionView.reloadData()

                // We must send a notification in case we start following someone.
                NotificationService.shared.uploadNotification(type: .follow,
                                                              user: self.user)
            }
        }
    }
    
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}
