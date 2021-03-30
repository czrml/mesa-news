//
//  HighlightsUseCase.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation

protocol GetHighlightsUseCase: UseCase {
    func callAsFunction() -> UseCaseResult<[Article]>
}

final class DefaultGetHighlightsUseCase: GetHighlightsUseCase {
    
    private let newsRepository: NewsRepository
    
    init(repository: NewsRepository) {
        self.newsRepository = repository
    }
    
    func callAsFunction() -> UseCaseResult<[Article]> {
        newsRepository.highlights()
    }
}
