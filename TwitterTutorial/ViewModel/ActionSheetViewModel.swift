//
//  ActionSheetViewModel.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 18/04/2020.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation

struct ActionSheetViewModel {
    
    private let user: User
    
    var option: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOptions: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOptions)
        }
        
        results.append(.report)
        return results
    }
    
    init(user: User) {
        self.user = user
    }
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
        case .follow(let user): return "Follow @\(user.username)"
        case .unfollow(let user): return "Unfollow @\(user.username)"
        case .report: return "Report Tweet"
        case .delete: return "Delete Tweet"
        }
    }
}
