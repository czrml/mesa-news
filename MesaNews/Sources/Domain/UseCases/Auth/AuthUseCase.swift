//
//  AuthUseCase.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation
import RxSwift

protocol AuthUseCase: UseCase {
    var state: Infallible<AuthState> { get }
    func login(with info: Login) -> UseCaseResult<Void>
    func signup(with info: Signup) -> UseCaseResult<Void>
    func logout()
}

final class DefaultAuthUseCase: AuthUseCase {
    
    private let disposeBag = DisposeBag()
    
    private var authorization = BehaviorSubject<Authorization?>(value: nil)
    
    private var authState: Infallible<AuthState> {
        authorization.map { $0 != nil ? .authorized : .unauthorized }.asInfallible(onErrorJustReturn: .unauthorized)
    }
    
    @Injected private var loginUseCase: LoginUseCase
    @Injected private var signupUseCase: SignupUseCase
    
    private let authRepository: AuthRepository
    
    init(repository: AuthRepository) {
        self.authRepository = repository
    }
    
    var state: Infallible<AuthState> { authState.asInfallible(onErrorJustReturn: .authorized) }
    
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
        self.authorization.onNext(nil)
    }
    
    private func handleAuthorization(result: UseCaseResultType<Authorization>) {
        guard case .success(let authorization) = result else {
            self.authorization.onNext(nil)
            return
        }
        
        self.authorization.onNext(authorization)
    }
}
