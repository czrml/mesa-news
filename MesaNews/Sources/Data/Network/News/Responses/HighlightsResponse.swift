//
//  HighlightsResponse.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

struct HighlightsResponse {
    let data: [ArticleResponse]
}

extension HighlightsResponse: Decodable { }

extension HighlightsResponse: DomainConvertibleType {
    var asDomain: [Article]? {
        data.compactMap(\.asDomain)
    }
}
