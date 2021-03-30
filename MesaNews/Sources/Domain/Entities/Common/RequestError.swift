//
//  RequestError.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

enum RequestError {
    case single(Error)
    case multiple([Error])
}

extension RequestError {
    struct Error {
        let code: Code
        let field: String?
        let message: String
    }
}

extension RequestError.Error {
    enum Code {
        case invalidCredentials
        case blank
        case invalidToken
        case invalid
        case taken
    }
}
