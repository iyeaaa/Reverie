//
//  PostListViewModel.swift
//  Reverie
//
//  Created by 이예인 on 2023/08/25.
//

import Foundation


struct NewsListCellViewModel {
    var news: News
    
    init(news: News) {
        self.news = news
    }
    
    var newsImageURL: URL? {
        return URL(string: news.urlToImage ?? "")
    }
    
    var title: String? {
        return news.title
    }
    
    var description: String? {
        return news.description
    }
    
    var date: String? {
        guard let publishAt = news.publishedAt else { return "Can't find" }
        return timeDifferenceInWords(publishAt)
    }
    
    var company: String? {
        return news.name
    }
    
    func timeDifferenceInWords(_ time: String) -> String {
        // Create Date objects for the given date and the current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let targetDate = dateFormatter.date(from: time) else { return "Can't find" }
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
}
