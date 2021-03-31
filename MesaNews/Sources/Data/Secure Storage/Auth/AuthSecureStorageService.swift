//
//  AuthSecureStorageService.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 30/03/21.
//

import Foundation
import KeychainAccess
import RxSwift

protocol AuthSecureStorageService: SecureStorageService {
    var token: String? { get }
    
    func save(token: String)
    func getToken() -> SecureResult<String?>
    func delete()
}

final class DefaultAuthSecureStorageService {
    private static let tokenIdentifier = MesaConfig.bundleId + "appToken"
    
    private(set) var token: String?
    
    private let provider = Keychain(service: MesaConfig.bundleId)
        .accessibility(.whenUnlocked)
        .synchronizable(false)
}

extension DefaultAuthSecureStorageService: AuthSecureStorageService {
    func save(token: String) {
        self.token = token
        provider[Self.tokenIdentifier] = token
    }
    
    func getToken() -> SecureResult<String?> {
        return .create { [weak self] infallible -> Disposable in
            let token = self?.provider[Self.tokenIdentifier]
            self?.token = token
            
            infallible(.next(token))
            
            return Disposables.create { }
        }
    }
    
    func delete() {
        provider[Self.tokenIdentifier] = nil
    }
}
