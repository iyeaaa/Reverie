//
//  Comment.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/18.
//

import UIKit
import Firebase

struct Comment {
    let ownerImageURL: String
    let ownerUserName: String
    let commentText: String
    let timestamp: Timestamp
    let uid: String
    
    init(dictionary: [String: Any]) {
        ownerImageURL = dictionary["ownerImageURL"] as? String ?? ""
        ownerUserName = dictionary["ownerUserName"] as? String ?? ""
        commentText = dictionary["comment"] as? String ?? ""
        timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        uid = dictionary["uid"] as? String ?? ""
    }
}
