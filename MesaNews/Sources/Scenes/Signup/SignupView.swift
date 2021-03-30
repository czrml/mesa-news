//
//  SignupView.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation
import UIKit
import RxSwift

final class SignupView<VM: SignupViewModel>: View<VM> {
    
    private let disposeBag = DisposeBag()
    
    private lazy var nameTextField: MesaTextField = {
        let field = MesaTextField(placeholder: MesaStrings.Signup.name)
        field.keyboardType = .namePhonePad
        field.textContentType = .name
        
        return field
    }()
    
    private lazy var emailTextField: MesaTextField = {
        let field = MesaTextField(placeholder: MesaStrings.Signup.email)
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.textContentType = .emailAddress
        
        return field
    }()
    
    private lazy var passwordTextField: MesaTextField = {
        let field = MesaTextField(placeholder: MesaStrings.Signup.password)
        field.keyboardType = .asciiCapable
        field.textContentType = .password
        field.isSecureTextEntry = true
        
        return field
    }()
    
    private lazy var nameErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emailErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var signupButton = MesaButton(title: MesaStrings.Signup.signup)
    
    private lazy var formStackView: UIStackView = {
        let formViews = [nameTextField, nameErrorLabel,
                         emailTextField, emailErrorLabel,
                         passwordTextField, passwordErrorLabel,
                         errorLabel,
                         signupButton]
        let stack = UIStackView(arrangedSubviews: formViews)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 8
        
        return stack
    }()
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = MesaColors.primaryBackground.color
        
        title = MesaStrings.Signup.title
    }

    override func layoutView() {
        super.layoutView()
        
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
        let input = SignupViewModelInput(nameValue: nameTextField.rx.text.asDriver(),
                                         emailValue: emailTextField.rx.text.asDriver(),
                                         passwordValue: passwordTextField.rx.text.asDriver(),
                                         signupButtonTap: signupButton.rx.tap)
        
        let output = viewModel.map(input: input)
        
        disposeBag.insert {
            output.isLoading
                .drive(signupButton.rx.isLoading,
                       nameTextField.rx.isDisabled,
                       emailTextField.rx.isDisabled,
                       passwordTextField.rx.isDisabled,
                       navigationItem.rx.hidesBackButton)
            
            output.nameErrorIsHidden.drive(nameErrorLabel.rx.isHidden)
            output.nameErrorMessageText.drive(nameErrorLabel.rx.text)
            
            output.emailErrorIsHidden.drive(emailErrorLabel.rx.isHidden)
            output.emailErrorMessageText.drive(emailErrorLabel.rx.text)
            
            output.passwordErrorIsHidden.drive(passwordErrorLabel.rx.isHidden)
            output.passwordErrorMessageText.drive(passwordErrorLabel.rx.text)
            
            output.errorIsHidden.drive(errorLabel.rx.isHidden)
            output.errorMessageText.drive(errorLabel.rx.text)
        
            output.signupButtonIsEnabled.drive(signupButton.rx.isEnabled)
        }
        
    }
}
