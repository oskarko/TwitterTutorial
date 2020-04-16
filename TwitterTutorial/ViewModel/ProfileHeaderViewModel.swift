//
//  ProfileHeaderViewModel.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 13/04/2020.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: 2, text: "following")
    }
    
    var actionButtonTitle: String {
        // If user is current user set to edit profile
        // else figure out following/not following
        if user.isCurrentUser {
            return "Edit Profile"
        } else {
            return user.isFollowed ? "Following" : "Follow"
        }
    }
    
    init(user: User) {
        self.user = user
        
        self.usernameText = "@" + user.username
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize:14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize:14),
                                                                                   NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        return attributedTitle
    }
}
