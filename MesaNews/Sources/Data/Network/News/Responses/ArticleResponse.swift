//
//  ArticleResponse.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 27/03/21.
//  Copyright © 2021 Mesa news. All rights reserved.
//

import Foundation

struct ArticleResponse {
    let title: String
    let description: String
    let content: String
    let author: String
    let publishedAt: String
    let highlight: Bool
    let url: String
    let imageUrl: String
}

extension ArticleResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case content
        case author
        case highlight
        case url
        case publishedAt = "published_at"
        case imageUrl = "image_url"
    }
}

extension ArticleResponse: DomainConvertibleType {
    var asDomain: Article? {
        let formatter = MesaServerDateFormatter()
        
        guard let published = formatter.date(from: publishedAt),
              let url = URL(string: url),
              let image = URL(string: imageUrl)
        else {
            return nil
        }
        
        return Article(title: title,
                       description: description,
                       content: content,
                       author: author,
                       published: published,
                       highlight: highlight,
                       url: url,
                       image: image)
    }
}
