//
//  NewsService.swift
//  Reverie
//
//  Created by 이예인 on 2023/08/24.
//

import Foundation

struct NewsService {
    
    private static let urlString = "https://newsapi.org/v2/top-headlines?country=us"
    
    private struct NewsCodable: Codable {
        let status: String?
        let totalResults: Int?
        let articles: [Article]?
        
        struct Article: Codable {
            let source: Source?
            let author: String?
            let title: String?
            let description: String?
            let url: String?
            let urlToImage: String?
            let publishedAt: String?
            let content: String?
            
            struct Source: Codable {
                let id: String?
                let name: String?
            }
        }
        
        func toNews() -> [News] {
            var newsList = [News]()
            for article in articles ?? [] {
                newsList.append(News(id: article.source?.id,
                                     name: article.source?.name,
                                     company: article.author,
                                     title: article.title,
                                     description: article.description,
                                     url: article.url,
                                     urlToImage: article.urlToImage,
                                     publishedAt: article.publishedAt,
                                     content: article.content))
            }
            return newsList
        }
    }
    
    static func fetchNews(page: Int, category: String, complete: @escaping ([News]) -> Void) {
        var urlString = urlString
        urlString += "&apikey=\(Bundle.main.apiKey)"
        urlString += "&category=\(category)"
        urlString += "&page=\(page)"
        print(urlString)
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("뉴스 호출 중 에러생김: \(error)")
                return
            }
            
            guard let data = data else { return print("데이터 불러오기 오류") }
            
            let jsonNews: NewsService.NewsCodable
            
            do {
                jsonNews = try JSONDecoder().decode(NewsCodable.self, from: data)
            } catch {
                print("json error: \(error)")
                return
            }
            
            complete(jsonNews.toNews())
        }.resume()
    }
}
