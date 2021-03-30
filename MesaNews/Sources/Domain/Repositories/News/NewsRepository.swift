//
//  NewsRepository.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

protocol NewsRepository: Repository {
    func news(currentPage: Int, itemsCount: Int, publishDate: Date?) -> RepositoryResult<Paginated<Article>>
    func highlights() -> RepositoryResult<[Article]>
}
