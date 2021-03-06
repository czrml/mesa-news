//
//  AppDelegate+Injection.swift
//  Sudo
//
//  Created by Cezar Mauricio on 30/07/20.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerRepositoriesInjection()
        registerUseCasesInjection()
        registerServicesInjection()
    }
    
    public static func registerRepositoriesInjection() {
        register { DefaultAuthRepository(networkService: resolve(), secureStorageService: resolve()) as AuthRepository }
            .scope(.application)
        
        register { DefaultNewsRepository(networkService: resolve()) as NewsRepository }
            .scope(.application)
    }
    
    public static func registerUseCasesInjection() {
        register { DefaultAuthUseCase(repository: resolve()) as AuthUseCase }
            .scope(.application)
        
        register { DefaultGetAuthorizationUseCase(repository: resolve()) as GetAuthorizationUseCase }
            .scope(.application)
        
        register { DefaultSaveAuthorizationUseCase(repository: resolve()) as SaveAuthorizationUseCase }
            .scope(.application)
        
        register { DefaultDeleteAuthorizationUseCase(repository: resolve()) as DeleteAuthorizationUseCase }
            .scope(.application)
        
        register { DefaultLoginUseCase(repository: resolve()) as LoginUseCase }
            .scope(.application)
        
        register { DefaultSignupUseCase(repository: resolve()) as SignupUseCase }
            .scope(.application)
        
        register { DefaultGetNewsUseCase(repository: resolve()) as GetNewsUseCase }
            .scope(.application)
        
        register { DefaultGetHighlightsUseCase(repository: resolve()) as GetHighlightsUseCase }
            .scope(.application)
    }
    
    public static func registerServicesInjection() {
        register { DefaultAuthSecureStorageService() as AuthSecureStorageService }
            .scope(.application)
        
        register { DefaultAuthNetworkService() as AuthNetworkService }
            .scope(.application)
        
        register { DefaultNewsNetworkService() as NewsNetworkService }
            .scope(.application)
    }
}
