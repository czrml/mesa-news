//
//  LoginViewModel.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation
import RxSwift
import RxCocoa

struct LoginViewModelInput {
    let emailValue: Driver<String?>
    let passwordValue: Driver<String?>
    let signupButtonTap: ControlEvent<Void>
    let loginButtonTap: ControlEvent<Void>
}

struct LoginViewModelOutput {
    let isLoading: Driver<Bool>
    let errorIsHidden: Driver<Bool>
    let errorMessageText: Driver<String?>
    let continueButtonIsEnabled: Driver<Bool>
}

enum LoginViewModelDelegateAction {
    case signup
    case loggedIn
}

protocol LoginViewModel: ViewModel where Input == LoginViewModelInput,
                                         Output == LoginViewModelOutput,
                                         DelegateAction == LoginViewModelDelegateAction { }

// MARK: - Default implementation
final class DefaultLoginViewModel: LoginViewModel {
    
    private let disposeBag = DisposeBag()
    @Injected private var authUseCase: AuthUseCase
    
    private let delegateAction = PublishSubject<LoginViewModelDelegateAction>()
}

// MARK: Binding Map
extension DefaultLoginViewModel {
    func map(input: LoginViewModelInput) -> LoginViewModelOutput {
        let isLoading = BehaviorRelay(value: false)
        
        let errorMessageText = BehaviorRelay<String?>(value: nil)
        
        let errorIsHidden = errorMessageText.map { $0 == nil }
        
        let emailInput = input.emailValue.map(Email.init)
        let passwordInput = input.passwordValue.map(Password.init)
        
        let continueButtonIsEnabled = Driver.combineLatest(emailInput, passwordInput)
            .map { email, password in email != nil && password != nil }
        
        input.signupButtonTap
            .map { .signup }
            .bind(onNext: delegate)
            .disposed(by: disposeBag)
        
        input.loginButtonTap
            .withLatestFrom(Driver.combineLatest(emailInput, passwordInput))
            .compactMap { email, password -> Login? in
                guard let email = email, let password = password else { return nil }
                return Login(email: email, password: password)
            }
            .do { _ in errorMessageText.accept(nil) }
            .do { _ in isLoading.accept(true) }
            .flatMap(authUseCase.login)
            .subscribe(with: self) { viewModel, result in
                isLoading.accept(false)
                
                switch result {
                case .success:
                    viewModel.delegate(action: .loggedIn)
                case .failure(.request(.single(let error))):
                    errorMessageText.accept("⚠️ " + error.message)
                case .failure:
                    errorMessageText.accept(MesaStrings.Error.unknown)
                }
            }.disposed(by: disposeBag)
        
        return Output(isLoading: isLoading.asDriver(),
                      errorIsHidden: errorIsHidden.asDriver(onErrorJustReturn: true),
                      errorMessageText: errorMessageText.asDriver(),
                      continueButtonIsEnabled: continueButtonIsEnabled.asDriver())
    }
}

// MARK: - Action Delegate
extension DefaultLoginViewModel {
    var onDelegatedAction: Observable<LoginViewModelDelegateAction> { delegateAction }

    func delegate(action: LoginViewModelDelegateAction) { delegateAction.onNext(action) }
}
