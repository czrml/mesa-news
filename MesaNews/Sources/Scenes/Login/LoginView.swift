//
//  LoginView.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation
import UIKit
import RxSwift

final class LoginView<VM: LoginViewModel>: View<VM> {
    
    private let disposeBag = DisposeBag()
    
    private lazy var signUpButton = UIBarButtonItem(title: MesaStrings.Login.signup,
                                                    style: .plain,
                                                    target: nil,
                                                    action: nil)
    
    private lazy var emailTextField: MesaTextField = {
        let field = MesaTextField(placeholder: MesaStrings.Login.email)
        field.keyboardType = .emailAddress
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textContentType = .emailAddress
        
        return field
    }()
    
    private lazy var passwordTextField: MesaTextField = {
        let field = MesaTextField(placeholder: MesaStrings.Login.password)
        field.keyboardType = .asciiCapable
        field.textContentType = .password
        field.isSecureTextEntry = true
        
        if #available(iOS 12.0, *) {
            field.passwordRules = .none
        }
        
        return field
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var loginButton = MesaButton(title: MesaStrings.Login.login)
    
    private lazy var formStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, errorLabel, loginButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 8
        
        return stack
    }()
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = MesaColors.primaryBackground.color
        
        title = MesaStrings.Login.title
    }

    override func layoutView() {
        super.layoutView()
        
        navigationItem.rightBarButtonItem = signUpButton
        
        addSubview(formStackView) { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerY.lessThanOrEqualTo(view.snp.centerY)
            
            keyboardAvoidConstraint = make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom)
                .inset(24).constraint
            keyboardAvoidBottomInset = 16
            keyboardAvoidDefaultOffset = 24
        }

    }
    
    override func bindView() {
        let input = LoginViewModelInput(emailValue: emailTextField.rx.text.asDriver(),
                                        passwordValue: passwordTextField.rx.text.asDriver(),
                                        signupButtonTap: signUpButton.rx.tap,
                                        loginButtonTap: loginButton.rx.tap)
        
        let output = viewModel.map(input: input)
        
        disposeBag.insert {
            output.isLoading
                .drive(loginButton.rx.isLoading,
                       emailTextField.rx.isDisabled,
                       passwordTextField.rx.isDisabled,
                       signUpButton.rx.isDisabled)
            
            output.errorIsHidden.drive(errorLabel.rx.isHidden)
            output.errorMessageText.drive(errorLabel.rx.text)
        
            output.continueButtonIsEnabled.drive(loginButton.rx.isEnabled)
        }
    }
}
