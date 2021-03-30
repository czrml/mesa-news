//
//  TokenResponse.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 27/03/21.
//

import Foundation

struct TokenResponse {
    let token: String
}

extension TokenResponse: Decodable { }

extension TokenResponse: DomainConvertibleType {
    var asDomain: Authorization? {
        Authorization(token: token)
    }
}
