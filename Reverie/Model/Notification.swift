//
//  Notification.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/20.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like: return " liked your post."
        case .follow: return " started following you."
        case .comment: return " commented on your post."
        }
    }
}

struct Notification {
    let uid: String
    let profileImageURL: String
    let thinkImageURL: String?
    let thinkID: String?
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    let username: String
    var userIsFollowd = false
    
    init(dictionary: [String: Any]) {
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.thinkID = dictionary["postID"] as? String ?? ""
        self.thinkImageURL = dictionary["postImageURL"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
    }
}
