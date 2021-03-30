//
//  LoginUseCase.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation

protocol LoginUseCase: UseCase {
    func callAsFunction(with info: Login) -> UseCaseResult<Authorization>
}

final class DefaultLoginUseCase: LoginUseCase {
    
    private let authRepository: AuthRepository
    
    init(repository: AuthRepository) {
        self.authRepository = repository
    }
    
    func callAsFunction(with info: Login) -> UseCaseResult<Authorization> {
        return authRepository.login(info)
    }
}
