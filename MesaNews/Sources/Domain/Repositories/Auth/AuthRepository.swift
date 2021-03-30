//
//  AuthRepository.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

protocol AuthRepository: Repository {
    func login(_ info: Login) -> RepositoryResult<Authorization>
    func signup(_ info: Signup) -> RepositoryResult<Authorization>
}
