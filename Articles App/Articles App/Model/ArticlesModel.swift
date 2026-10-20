//
//  ArticlesModel.swift
//  Articles App
//
//  Created by Kirit on 14/10/26.
//


import Foundation
import SwiftyJSON

struct ArticlesResponse {
    let status: String
    let totalResults: Int
    let articles: [Article]

    init(json: JSON) {
        self.status = json["status"].stringValue
        self.totalResults = json["totalResults"].intValue
        self.articles = json["articles"].arrayValue.map {
            Article(json: $0)
        }
    }
}

struct Article {
    let source: ArticleSource
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    init(json: JSON) {
        self.source = ArticleSource(json: json["source"])
        self.author = json["author"].string
        self.title = json["title"].stringValue
        self.description = json["description"].string
        self.url = json["url"].string
        self.urlToImage = json["urlToImage"].string
        self.publishedAt = json["publishedAt"].string
        self.content = json["content"].string
    }
}

struct ArticleSource {
    let id: String?
    let name: String?

    init(json: JSON) {
        self.id = json["id"].string
        self.name = json["name"].string
    }
}
