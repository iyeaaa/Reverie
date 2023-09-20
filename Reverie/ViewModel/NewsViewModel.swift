//
//  NewsCellViewModel.swift
//  Reverie
//
//  Created by 이예인 on 2023/08/26.
//

import UIKit

struct NewsViewModel {
    
    var news: News
    
    init(news: News) {
        self.news = news
    }
    
//    var userProfileImageUrl: URL? { return URL(string: post.ownerImageUrl) }
    
    var username: String { return news.name ?? "unknown" }
    
    var title: String { return news.title ?? "no title" }
    
    var imageUrl: URL? {
        return URL(string: news.urlToImage ?? "")
    }
    
    var likes: Int { return 4 }
    
    var likesLabelText: String {
        let likeString = addComma(likes)
        return "좋아요 \(likeString)개"
    }
    
    var likeButtonImage: UIImage {
        return UIImage(named: true ? "like_selected" : "like_unselected")!
    }
    
    var likeButtonTintColor: UIColor {
        return true ? .red : .black
    }
    
    var timestampString: String? {
        guard let publishAt = news.publishedAt else { return "can't find" }
        return timeDifferenceInWords(publishAt)
    }
    
    func timeDifferenceInWords(_ time: String) -> String {
        // Create Date objects for the given date and the current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let targetDate = dateFormatter.date(from: time) else { return "can't find" }
        
        let currentDate = Date()
        
        // Calculate the date difference using Calendar
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour], from: targetDate, to: currentDate)
        
        // Convert the difference to weeks, days, and hours and return as a string
        if let hours = dateComponents.hour {
            if hours > 0 {
                return "\(hours) hours ago"
            } else {
                return "just now"
            }
        } else {
            return "Can't find"
        }
    }

    var content: String {
        guard let content = news.content else { return "내용 없음" }
        return "\(content)\n\(content)\n\(content)\n\(content)\n\(content)\n\(content)\n\(content)\n"
    }
    
    func addComma(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

