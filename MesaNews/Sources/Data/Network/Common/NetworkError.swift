//
//  NetworkError.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError
    
    case request(NetworkRequestError)

    case unknown
    
    init?(from httpCode: Int) {
        switch httpCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 500...:
            self = .serverError
        default:
            return nil
        }
    }
}

extension NetworkError: DomainConvertibleType {
    var asDomain: DomainError? {
        switch self {
        case .badRequest:
            return  .badRequest
        case .unauthorized:
            return .unauthorized
        case .forbidden:
            return .forbidden
        case .notFound:
            return .notFound
        case .serverError:
            return .serverError
        case .request(let error):
            guard let error = error.asDomain else { return nil }
            return .request(error: error)
        case .unknown:
            return .unknown
        }
    }
}
