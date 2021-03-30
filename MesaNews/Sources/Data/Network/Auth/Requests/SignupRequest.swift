//
//  SignupRequest.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 27/03/21.
//

import Foundation

struct SignupRequest {
    let name: String
    let email: String
    let password: String
}

extension SignupRequest: Encodable { }

extension SignupRequest: DataConvertibleType {
    init(from domain: Signup) {
        self.name = domain.name
        self.email = domain.email.value
        self.password = domain.password.value
    }
}
