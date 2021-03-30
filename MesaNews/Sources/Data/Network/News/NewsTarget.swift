//
//  NewsTarget.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation
import Moya

enum NewsTarget {
    case news(currentPage: Int, perPage: Int, publishAt: String?)
    case highlights
}

extension NewsTarget: MesaTargetType {
    var baseURL: URL {
        return URL(string: MesaConfig.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .news(let currentPage, let perPage, let publishAt):
            return "/v1/client/news?current_page=\(currentPage)&per_page=\(perPage)&published_at=\(publishAt ?? "")"
        case .highlights:
            return "/v1/client/news/highlights"
        }
    }
    
    var method: Method {
        switch self {
        case .news,
             .highlights:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .news,
             .highlights:
            return .requestPlain
        }
    }
}
