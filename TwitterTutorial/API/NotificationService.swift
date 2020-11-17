//
//  NotificationService.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 23/10/20.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation
import Firebase

struct NotificationService {
    static let shared = NotificationService()

    func uploadNotification(toUser user: User,
                            type: NotificationType,
                            tweetID: String? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]

        if let tweetID = tweetID {
            values["tweetID"] = tweetID
        }

        REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
    }

    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        var notifications = [Notification]()

        guard let uid = Auth.auth().currentUser?.uid else { return }

        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }

            UserService.shared.fetchUser(uid: uid) { (user) in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }

}
