//
//  DefaultAuthRepository.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

final class DefaultAuthRepository: AuthRepository {
    
    private let networkService: AuthNetworkService

    init(networkService: AuthNetworkService) {
        self.networkService = networkService
    }
    
    func login(_ info: Login) -> RepositoryResult<Authorization> {
        let request = SigninRequest(from: info)
        
        return networkService.login(request: request).mapToDomain(from: TokenResponse.self)
    }
    
    func signup(_ info: Signup) -> RepositoryResult<Authorization> {
        let request = SignupRequest(from: info)
        
        return networkService.signup(request: request).mapToDomain(from: TokenResponse.self)
    }
}
