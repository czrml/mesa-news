//
//  AuthNetworkService.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 27/03/21.
//

import Foundation
import RxSwift

protocol AuthNetworkService: NetworkService {
    func login(request: SigninRequest) -> NetworkResult<TokenResponse>
    func signup(request: SignupRequest) -> NetworkResult<TokenResponse>
}

final class DefaultAuthNetworkService {

    private let provider: MesaProvider<AuthTarget>

    init(provider: MesaProvider<AuthTarget> = .init()) {
        self.provider = provider
    }
}

extension DefaultAuthNetworkService: AuthNetworkService {
    func login(request: SigninRequest) -> NetworkResult<TokenResponse> {
        provider.request(.signin(request: request))
    }
    
    func signup(request: SignupRequest) -> NetworkResult<TokenResponse> {
        provider.request(.signup(request: request))
    }
}
