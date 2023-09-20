//
//  Constants.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/11.
//

import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_THINKS = Firestore.firestore().collection("posts")
let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")

struct Constant {
    static let separateText = "@#@#"
}

