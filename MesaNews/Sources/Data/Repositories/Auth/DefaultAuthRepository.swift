//
//  DefaultAuthRepository.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

final class DefaultAuthRepository: AuthRepository {
    
    private let networkService: AuthNetworkService
    private let secureStorageService: AuthSecureStorageService

    init(networkService: AuthNetworkService, secureStorageService: AuthSecureStorageService) {
        self.networkService = networkService
        self.secureStorageService = secureStorageService
    }
    
    func login(_ info: Login) -> RepositoryResult<Authorization> {
        let request = SigninRequest(from: info)
        
        return networkService.login(request: request).mapToDomain(from: TokenResponse.self)
    }
    
    func signup(_ info: Signup) -> RepositoryResult<Authorization> {
        let request = SignupRequest(from: info)
        
        return networkService.signup(request: request).mapToDomain(from: TokenResponse.self)
    }
    
    func getAuthorization() -> RepositoryInfallibleResult<String?> {
        secureStorageService.getToken()
    }
    
    func saveAuthorization(_ auth: Authorization) {
        secureStorageService.save(token: auth.token)
    }
    
    func deleteAuthorization() {
        secureStorageService.delete()
    }
}
