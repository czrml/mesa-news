//
//  NetworkRequestError.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

struct NetworkRequestError {
    let error: ErrorType
}

extension NetworkRequestError: Decodable {
    init(from decoder: Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        
        guard let singleError = try? singleContainer.decode(Error.self) else {
            let multipleContainer = try decoder.container(keyedBy: CodingKeys.self)
            let multipleError = try multipleContainer.decode([Error].self, forKey: .errors)
            
            error = .multiple(multipleError)
            return
        }
        
        error = .single(singleError)
    }
    
    enum CodingKeys: String, CodingKey {
        case errors
    }
}

extension NetworkRequestError: DomainConvertibleType {
    var asDomain: RequestError? { error.asDomain }
}

extension NetworkRequestError  {
    enum ErrorType {
        case single(Error)
        case multiple([Error])
    }
}

extension NetworkRequestError.ErrorType: DomainConvertibleType  {
    var asDomain: RequestError? {
        switch self {
        case .single(let error):
            guard let error = error.asDomain else { return nil }
            return .single(error)
        case .multiple(let errors):
            return .multiple(errors.compactMap(\.asDomain))
        }
    }
}

extension NetworkRequestError {
    struct Error: Decodable {
        let code: ErrorCode
        let field: String?
        let message: String
    }
}

extension NetworkRequestError.Error: DomainConvertibleType {
    var asDomain: RequestError.Error? {
        guard let code = code.asDomain else { return nil }
        
        return RequestError.Error(code: code,
                                  field: field,
                                  message: message) }
}

extension NetworkRequestError.Error {
    enum ErrorCode: String, Decodable {
        case invalidCredentials = "INVALID_CREDENTIALS"
        case blank = "BLANK"
        case invalidToken = "INVALID_TOKEN"
        case invalid = "INVALID"
        case taken = "TAKEN"
    }
}

extension NetworkRequestError.Error.ErrorCode: DomainConvertibleType {
    var asDomain: RequestError.Error.Code? {
        switch self {
        case .invalidCredentials: return .invalidCredentials
        case .blank: return .blank
        case .invalidToken: return .invalidToken
        case .invalid: return .invalid
        case .taken: return .taken
        }
    }
}
