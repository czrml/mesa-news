//
//  DomainError.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

enum DomainError: Error {
    case badRequest
    case forbidden
    case unauthorized
    case notFound
    case duplicated
    case serverError
    case request(error: RequestError)
    case unknown
}
