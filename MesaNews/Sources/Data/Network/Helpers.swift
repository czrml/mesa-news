//
//  Helpers.swift
//  Sudo
//
//  Created by Cezar Mauricio on 28/05/20.
//

import Foundation
import RxSwift

class MesaServerDateFormatter: DateFormatter {
    override init() {
        super.init()
        
        dateFormat = "yyyy-MM-dd"
        timeZone = TimeZone(secondsFromGMT: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MesaJsonEncoder: JSONEncoder {
    override init() {
        super.init()
        
        let dateFormatter = MesaServerDateFormatter()
        dateEncodingStrategy = .formatted(dateFormatter)
    }
}

class MesaJsonDecoder: JSONDecoder {
    override init() {
        super.init()
        
        let dateFormatter = MesaServerDateFormatter()
        dateDecodingStrategy = .formatted(dateFormatter)
    }
}

extension Infallible {
    func mapToDomain<T: DomainConvertibleType>(from responseType: T.Type)
    -> Infallible<Result<T.DomainType, DomainError>> where Element == Result<T, NetworkError> {
        return self.map { response in
            switch response {
            case .success(let domainType):
                guard let domainResponse = domainType.asDomain else {
                    return .failure(.serverError)
                }
                
                return .success(domainResponse)
            case .failure(let error):
                return .failure(error.asDomain ?? .unknown)
            }
            
        }
    }
    
//    func mapToDomain<T, R>(_ mapper: @escaping (T) -> R)
//        -> RepositoryResult<R> where Element == NetworkResult<T> {
//        return self.asObservable().map { response -> RepositoryResultType<R> in
//            switch response {
//            case .success(let type):
//                let returnType = mapper(type)
//
//                return .success(returnType)
//            case .failure(let error):
//                return .failure(error.asDomain ?? .unknown)
//            }
//        }
//    }
//
//    func mapToDomain<T, R>(_ mapper: @escaping (T) -> R?)
//        -> RepositoryResult<R> where Element == NetworkResult<T> {
//        return self.asObservable().map { response -> RepositoryResultType<R> in
//            switch response {
//            case .success(let type):
//                if let returnType = mapper(type) {
//                    return .success(returnType)
//                } else {
//                    return .failure(.badRequest)
//                }
//            case .failure(let error):
//                return .failure(error.asDomain ?? .unknown)
//            }
//        }
//    }
}
