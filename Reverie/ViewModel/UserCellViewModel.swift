//
//  UserCellViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/13.
//

import UIKit

struct UserCellViewModel {
    
    private let user: User
    
    var profileImageUrl: URL? {
        URL(string: user.profileImageUrl)
    }
    
    var username: String {
        user.username
    }
    
    var fullname: String {
        user.fullname
    }
    
    init(user: User) {
        self.user = user
    }
    
    
}
