//
//  DefaultNewsRepository.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation

final class DefaultNewsRepository: NewsRepository {
    
    private let networkService: NewsNetworkService

    init(networkService: NewsNetworkService) {
        self.networkService = networkService
    }
    
    func news(currentPage: Int, itemsCount: Int, publishDate: Date?) -> RepositoryResult<Paginated<Article>> {
        var date: String?
        
        if let publishDate = publishDate {
            date = MesaServerDateFormatter().string(from: publishDate)
        }
        
        return networkService
            .news(currentPage: currentPage, perPage: itemsCount, publishAt: date)
            .mapToDomain(from: NewsResponse.self)
    }
    
    func highlights() -> RepositoryResult<[Article]> {
        return networkService.highlights().mapToDomain(from: HighlightsResponse.self)
    }
}
