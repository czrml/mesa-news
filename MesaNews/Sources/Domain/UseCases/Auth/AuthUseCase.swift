//
//  AuthUseCase.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation
import RxSwift

protocol AuthUseCase: UseCase {
    var authorization: Infallible<Authorization?> { get }
    var state: Infallible<AuthState> { get }
    func login(with info: Login) -> UseCaseResult<Void>
    func signup(with info: Signup) -> UseCaseResult<Void>
    func logout()
}

final class DefaultAuthUseCase: AuthUseCase {
    
    private let disposeBag = DisposeBag()
    
    @Injected private var loginUseCase: LoginUseCase
    @Injected private var signupUseCase: SignupUseCase
    @Injected private var getAuthUseCase: GetAuthorizationUseCase
    @Injected private var saveAuthUseCase: SaveAuthorizationUseCase
    @Injected private var deleteAuthUseCase: DeleteAuthorizationUseCase
    
    private var auth = BehaviorSubject<Authorization?>(value: nil)

    var authorization: Infallible<Authorization?> { auth.asInfallible(onErrorJustReturn: nil) }
    var state: Infallible<AuthState> { authorization.map { $0 != nil ? .authorized : .unauthorized } }
    
    private let authRepository: AuthRepository
    
    init(repository: AuthRepository) {
        self.authRepository = repository
        
        getAuthUseCase()
            .compactMap { $0 }
            .map(Authorization.init)
            .bind(to: auth)
            .disposed(by: disposeBag)
    }
    
    func login(with info: Login) -> UseCaseResult<Void> {
        let login = loginUseCase(with: info)
        
        login.bind(onNext: handleAuthorization).disposed(by: disposeBag)
            
        return login.map { $0.map { _ in } }
    }
    
    func signup(with info: Signup) -> UseCaseResult<Void> {
        let signup = signupUseCase(with: info)
        
        signup.bind(onNext: handleAuthorization).disposed(by: disposeBag)
        
        return signup.map { $0.map { _ in } }
    }
    
    func logout() {
        self.auth.onNext(nil)
        self.deleteAuthUseCase()
    }
    
    private func handleAuthorization(result: UseCaseResultType<Authorization>) {
        guard case .success(let authorization) = result else {
            self.auth.onNext(nil)
            self.deleteAuthUseCase()
            return
        }
        
        self.saveAuthUseCase(authorization)
        self.auth.onNext(authorization)
    }
}
