//
//  SaveAuthorizationUseCase.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 30/03/21.
//

import Foundation

protocol SaveAuthorizationUseCase: UseCase {
    func callAsFunction(_ auth: Authorization)
}

final class DefaultSaveAuthorizationUseCase: SaveAuthorizationUseCase {
    
    private let authRepository: AuthRepository
    
    init(repository: AuthRepository) {
        self.authRepository = repository
    }
    
    func callAsFunction(_ auth: Authorization) {
        authRepository.saveAuthorization(auth)
    }
}
