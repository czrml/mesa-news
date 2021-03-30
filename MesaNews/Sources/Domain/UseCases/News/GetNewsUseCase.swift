//
//  GetNewsUseCase.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation
import RxSwift
import RxRelay

protocol GetNewsUseCase: UseCase {
    var news: Infallible<[Article]> { get }
    func callAsFunction(from date: Date?) -> UseCaseResult<Bool>
}

final class DefaultGetNewsUseCase: GetNewsUseCase {
    
    private let newsRepository: NewsRepository
    
    private let disposeBag = DisposeBag()
    private let newsList = BehaviorRelay<[Article]>(value: [])
    
    private var currentPage = 0
    private var pageCount: Int?
    private let itemsCount = 20
    private var currentDate: Date?
    
    init(repository: NewsRepository) {
        self.newsRepository = repository
    }
    
    var news: Infallible<[Article]> { newsList.asInfallible(onErrorJustReturn: []) }
    
    func callAsFunction(from date: Date?) -> UseCaseResult<Bool> {
        if currentDate != date {
            currentPage = 0
            pageCount = nil
            currentDate = date
        }
        
        if let pageCount = pageCount, currentPage >= pageCount {
            return .just(.success(false))
        }
        
        let getNews = newsRepository.news(currentPage: currentPage + 1, itemsCount: itemsCount, publishDate: date)
        
        getNews
            .compactMap { try? $0.get() }
            .withUnretained(self)
            .do { useCase, pagination in
                useCase.currentPage = pagination.page.currentPage
                useCase.pageCount = pagination.page.pageCount
            }
            .map { useCase, pagination in useCase.newsList.value + pagination.content }
            .asObservable()
            .bind(to: newsList)
            .disposed(by: disposeBag)
        
        return getNews.map { result in result.map { $0.page.currentPage < $0.page.pageCount } }
    }
}
