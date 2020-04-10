//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 10/04/2020.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named:"new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonTapped() {
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor,
                            paddingBottom: 64,
                            paddingRight: 16,
                            width: 56,
                            height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers() {
        
        let feed = FeedController()
        let feedNav = templateNavigationController(image: UIImage(named: "home_unselected"),
                                                   rootViewController: feed)
        
        let explore = ExploreController()
        let exploreNav = templateNavigationController(image: UIImage(named: "search_unselected"),
                                                      rootViewController: explore)
        
        let notifications = NotificationsController()
        let notificationsNav = templateNavigationController(image: UIImage(named: "like_unselected"),
                                                            rootViewController: notifications)
        
        let conversations = ConversationsController()
        let conversationsNav = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"),
                                                            rootViewController: conversations)
        
        viewControllers = [feedNav, exploreNav, notificationsNav, conversationsNav]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        return nav
    }

}
