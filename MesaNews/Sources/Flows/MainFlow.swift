//
//  MainFlow.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation
import UIKit
import RxSwift

final class MainFlow: FlowCoordinator {
    
    let navigationController: UINavigationController
    
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController = .init()) {
        self.navigationController = navigationController
        navigationController.navigationBar.tintColor = MesaColors.accent.color
        navigationController.navigationBar.barTintColor = MesaColors.primaryBackground.color
    }
    
    func start() {
        showLoginView()
    }
    
    private func showLoginView() {
        let viewModel = DefaultLoginViewModel()
        let view = LoginView(viewModel: viewModel)
        
        viewModel.onDelegatedAction
            .subscribe(with: self) { flow, action in
                switch action {
                case .loggedIn:
                    break
                case .signup:
                    flow.showSignupView()
                }
            }.disposed(by: disposeBag)
        
        navigationController.pushViewController(view, animated: true)
    }
    
    private func showSignupView() {
        let viewModel = DefaultSignupViewModel()
        let view = SignupView(viewModel: viewModel)
        
        viewModel.onDelegatedAction
            .subscribe(with: self) { _, action in
                switch action {
                case .loggedIn:
                    break
                }
            }.disposed(by: disposeBag)
        
        navigationController.pushViewController(view, animated: true)
    }
}
