//
//  FeedCellViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/15.
//

import UIKit

struct ThinkCellViewModel {
    
    var think: Think
    
    init(think: Think) {
        self.think = think
    }
    
    var userProfileImageUrl: URL? { return URL(string: think.ownerImageUrl) }
    
    var username: String { return think.ownerUsername }
    
    var imageUrl: URL? {
        return URL(string: think.imageUrl)
    }
    
    var likes: Int { return think.like }
    
    var likesLabelText: String {
        let likeString = addComma(likes)
        return "좋아요 \(likeString)개"
    }
    
    var likeButtonImage: UIImage {
        return UIImage(named: think.didLike ? "like_selected" : "like_unselected")!
    }
    
    var likeButtonTintColor: UIColor {
        return think.didLike ? .red : .black
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        return (formatter.string(from: think.timestamp.dateValue(), to: Date()) ?? "")
    }
    
    var title: String {
        return think.title
    }

    var content: String {
        return think.content
    }
    
    func addComma(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}
