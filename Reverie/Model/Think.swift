//
//  Post.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/15.
//

import UIKit
import Firebase

class Think {
    let title: String
    let content: String
    let timestamp: Timestamp
    let imageUrl: String
    let ownerUid: String
    var like: Int
    let thinkID: String
    let ownerImageUrl: String
    let ownerUsername: String
    var didLike = false
    
    init(thinkID: String, dictionary: [String: Any]) {
        self.thinkID = thinkID
        
        let caption = dictionary["caption"] as? String ?? ""
        let splitedCaption = caption.components(separatedBy: Constant.separateText)
        
        self.title = splitedCaption.first ?? "UNKOWN TITLE"
        self.content = splitedCaption.last ?? "UNKOWN CONTENT"
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.like = dictionary["likes"] as? Int ?? 0
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
}
