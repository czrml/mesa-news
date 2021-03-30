//
//  SignupViewModel.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation
import RxSwift
import RxCocoa

struct SignupViewModelInput {
    let nameValue: Driver<String?>
    let emailValue: Driver<String?>
    let passwordValue: Driver<String?>
    
    let signupButtonTap: ControlEvent<Void>
}

struct SignupViewModelOutput {
    let isLoading: Driver<Bool>
    
    let errorIsHidden: Driver<Bool>
    let errorMessageText: Driver<String?>
    let nameErrorIsHidden: Driver<Bool>
    let nameErrorMessageText: Driver<String?>
    let emailErrorIsHidden: Driver<Bool>
    let emailErrorMessageText: Driver<String?>
    let passwordErrorIsHidden: Driver<Bool>
    let passwordErrorMessageText: Driver<String?>
    
    let signupButtonIsEnabled: Driver<Bool>
}

enum SignupViewModelDelegateAction {
    case loggedIn
}

protocol SignupViewModel: ViewModel where Input == SignupViewModelInput,
                                          Output == SignupViewModelOutput,
                                          DelegateAction == SignupViewModelDelegateAction { }

// MARK: - Default implementation
final class DefaultSignupViewModel: SignupViewModel {
    
    private let disposeBag = DisposeBag()
    @Injected private var authUseCase: AuthUseCase
    
    private var delegateAction = PublishSubject<SignupViewModelDelegateAction>()
}

// MARK: Binding Map
extension DefaultSignupViewModel {
    func map(input: SignupViewModelInput) -> SignupViewModelOutput {
        let isLoading = BehaviorRelay(value: false)
        
        let formErrors = BehaviorRelay<[FormError]?>(value: nil)
        
        let errorMessageText = formErrors.map { $0?.filter { $0.field == .unknown } }
            .map { unknown in unknown?.reduce("", { $0.appending("\($1.message)\n") }) }
        let errorIsHidden = errorMessageText.map { $0 == nil }
        
        let nameErrorMessageText = formErrors.map { $0?.filter { $0.field == .name } }
            .map { unknown in unknown?.reduce("", { $0.appending("\($1.message)\n") }) }
        let nameErrorIsHidden = nameErrorMessageText.map { $0 == nil }
        
        let emailErrorMessageText = formErrors.map { $0?.filter { $0.field == .email } }
            .map { unknown in unknown?.reduce("", { $0.appending("\($1.message)\n") }) }
        let emailErrorIsHidden = emailErrorMessageText.map { $0 == nil }
        
        let passwordErrorMessageText = formErrors.map { $0?.filter { $0.field == .password } }
            .map { unknown in unknown?.reduce("", { $0.appending("\($1.message)\n") }) }
        let passwordErrorIsHidden = passwordErrorMessageText.map { $0 == nil }
        
        let emailInput = input.emailValue.map(Email.init)
        let passwordInput = input.passwordValue.map(Password.init)
        
        let signupButtonIsEnabled = Driver.combineLatest(input.nameValue, emailInput, passwordInput)
            .map { name, email, password in name != nil && email != nil && password != nil }
        
        input.signupButtonTap
            .withLatestFrom(Driver.combineLatest(input.nameValue, emailInput, passwordInput))
            .compactMap { name, email, password -> Signup? in
                guard let name = name, let email = email, let password = password else { return nil }
                return Signup(name: name, email: email, password: password)
            }
            .do { _ in formErrors.accept([]) }
            .do { _ in isLoading.accept(true) }
            .flatMap(authUseCase.signup)
            .subscribe(with: self) { viewModel, result in
                isLoading.accept(false)
                
                switch result {
                case .success:
                    viewModel.delegate(action: .loggedIn)
                case .failure(.request(.multiple(let errors))):
                    formErrors.accept(errors.map(FormError.init))
                case .failure:
                    let error = FormError(field: .unknown, message: MesaStrings.Error.unknown)
                    formErrors.accept([error])
                }
            }.disposed(by: disposeBag)
        
        return Output(isLoading: isLoading.asDriver(),
                      errorIsHidden: errorIsHidden.asDriver(onErrorJustReturn: true),
                      errorMessageText: errorMessageText.asDriver(onErrorJustReturn: nil),
                      nameErrorIsHidden: nameErrorIsHidden.asDriver(onErrorJustReturn: true),
                      nameErrorMessageText: nameErrorMessageText.asDriver(onErrorJustReturn: nil),
                      emailErrorIsHidden: emailErrorIsHidden.asDriver(onErrorJustReturn: true),
                      emailErrorMessageText: emailErrorMessageText.asDriver(onErrorJustReturn: nil),
                      passwordErrorIsHidden: passwordErrorIsHidden.asDriver(onErrorJustReturn: true),
                      passwordErrorMessageText: passwordErrorMessageText.asDriver(onErrorJustReturn: nil),
                      signupButtonIsEnabled: signupButtonIsEnabled.asDriver())
    }
}

// MARK: - Action Delegate
extension DefaultSignupViewModel {
    var onDelegatedAction: Observable<SignupViewModelDelegateAction> { delegateAction }

    func delegate(action: SignupViewModelDelegateAction) { delegateAction.onNext(action) }
}

// MARK: - Action Delegate
private extension DefaultSignupViewModel {
    struct FormError {
        let field: Field
        let message: String
    }
}

private extension DefaultSignupViewModel.FormError {
    init(from request: RequestError.Error) {
        self.message = request.message
        
        guard let field = request.field else {
            self.field = .unknown
            return
        }
        self.field = Field(rawValue: field) ?? .unknown
    }
    
    enum Field: String {
        case password
        case email
        case name
        case unknown
    }
}
