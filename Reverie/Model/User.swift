//
//  User.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/11.
//

import Foundation
import Firebase

class User {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let username: String
    let uid: String
    
    var isFollowed = false
    
    var stats: UserStats = UserStats(thinks: 0, followers: 0, following: 0)
    
    var isCurrentUser: Bool {
        return UserService.currentLoginUser?.uid == uid
    }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

struct UserStats {
    let thinks: Int
    let followers: Int
    let following: Int
}
