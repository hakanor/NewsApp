//
//  NewsService.swift
//  NewsApp
//
//  Created by Hakan Or on 21.07.2022.
//

import Foundation

public final class NewsService{
    private let API_KEY = "057e39594ea345b2a91c447168d070f1"
}

// 1 - request  & session
// 2 - response & data
// 3 - parsing  & json serialization
extension NewsService {
    
    func fetchNewsData(completion: @escaping (Result<[Article],Error>) -> Void ){
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=tr&apiKey=\(API_KEY)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
