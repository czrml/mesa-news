//
//  SignupUseCase.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation

protocol SignupUseCase: UseCase {
    func callAsFunction(with info: Signup) -> UseCaseResult<Authorization>
}

final class DefaultSignupUseCase: SignupUseCase {
    
    private let authRepository: AuthRepository
    
    init(repository: AuthRepository) {
        self.authRepository = repository
    }
    
    func callAsFunction(with info: Signup) -> UseCaseResult<Authorization> {
        return authRepository.signup(info)
    }
}
