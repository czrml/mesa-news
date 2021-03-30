//
//  SigninRequest.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 27/03/21.
//

import Foundation

struct SigninRequest {
    let email: String
    let password: String
}

extension SigninRequest: Encodable { }

extension SigninRequest: DataConvertibleType {
    init(from domain: Login) {
        self.email = domain.email.value
        self.password = domain.password.value
    }
}
