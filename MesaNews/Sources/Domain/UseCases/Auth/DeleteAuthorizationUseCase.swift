//
//  DeleteAuthorizationUseCase.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 30/03/21.
//

import Foundation

protocol DeleteAuthorizationUseCase: UseCase {
    func callAsFunction()
}

final class DefaultDeleteAuthorizationUseCase: DeleteAuthorizationUseCase {
    
    private let authRepository: AuthRepository
    
    init(repository: AuthRepository) {
        self.authRepository = repository
    }
    
    func callAsFunction() {
        authRepository.deleteAuthorization()
    }
}
