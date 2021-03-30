//
//  NewsNetworkService.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

protocol NewsNetworkService: NetworkService {
    func news(currentPage: Int, perPage: Int, publishAt: String?) -> NetworkResult<NewsResponse>
    func highlights() -> NetworkResult<HighlightsResponse>
}

final class DefaultNewsNetworkService {

    private let provider: MesaProvider<NewsTarget>

    init(provider: MesaProvider<NewsTarget> = .init()) {
        self.provider = provider
    }
}

extension DefaultNewsNetworkService: NewsNetworkService {
    func news(currentPage: Int, perPage: Int, publishAt: String?) -> NetworkResult<NewsResponse> {
        provider.request(.news(currentPage: currentPage, perPage: currentPage, publishAt: publishAt))
    }
    
    func highlights() -> NetworkResult<HighlightsResponse> {
        provider.request(.highlights)
    }
}
