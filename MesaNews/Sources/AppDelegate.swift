//
//  AppDelegate.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 24/03/21.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let disposeBag = DisposeBag()
    
    @Injected private var authUseCase: AuthUseCase
    
    private var coordinator: FlowCoordinator = MainFlow() { didSet { transitionWindow(to: coordinator) } }
    
    lazy var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = coordinator.navigationController
        window.backgroundColor = MesaColors.primaryBackground.color
        
        return window
    }()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
        
        authUseCase.state
            .subscribe(with: self) { app, state in
                switch state {
                case .authorized:
                    let flow = FeedFlow()
                    app.coordinator = flow
                case .unauthorized:
                    let flow = MainFlow()
                    app.coordinator = flow
                }
            }
            .disposed(by: disposeBag)
        
        return true
    }
    
    private func transitionWindow(to coordinator: FlowCoordinator) {
        guard let window = window else { return }
        
        window.rootViewController = coordinator.navigationController
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}
