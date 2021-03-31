//
//  GetAuthorizationUseCase.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 30/03/21.
//

import Foundation

protocol GetAuthorizationUseCase: UseCase {
    func callAsFunction() -> UseCaseInfallibleResult<String?>
}

final class DefaultGetAuthorizationUseCase: GetAuthorizationUseCase {
    
    private let authRepository: AuthRepository
    
    init(repository: AuthRepository) {
        self.authRepository = repository
    }
    
    func callAsFunction() -> UseCaseInfallibleResult<String?> {
        authRepository.getAuthorization()
    }
}
