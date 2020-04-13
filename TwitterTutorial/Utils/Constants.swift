//
//  Constants.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 11/04/2020.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

let REF_TWEETS = DB_REF.child("tweets")
