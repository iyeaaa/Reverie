//
//  ProfileHeaderViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/11.
//

import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var followButtonText: String {
        return user.isCurrentUser ? "Edit Profile" : (user.isFollowed ? "Following" : "Follow")
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUser || user.isFollowed ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isCurrentUser || user.isFollowed ? .black : .white
    }
    
    var numberOfThinks: NSAttributedString {
        return attributedStatText(value: user.stats.thinks, label: "게시물")
    }
    
    var numberOfFollowers: NSAttributedString {
        return attributedStatText(value: user.stats.followers, label: "팔로워")
    }
    
    var numberOfFollowings: NSAttributedString {
        return attributedStatText(value: user.stats.following, label: "팔로잉")
    }
    
    init(user: User) {
        self.user = user
    }
    
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        return attributedText
    }
}
