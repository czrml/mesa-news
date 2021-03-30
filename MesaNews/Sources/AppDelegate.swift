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
    
    var window: UIWindow?
    
    private let disposeBag = DisposeBag()
    
    @Injected private var authUseCase: AuthUseCase
    
    private let flowWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = MesaColors.primaryBackground.color
        return window
    }()
    
    private var coordinator: FlowCoordinator = MainFlow() {
        didSet {
            coordinator.start()
            flowWindow.rootViewController = coordinator.navigationController
            flowWindow.makeKeyAndVisible()
            UIView.transition(with: flowWindow,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            window = flowWindow
        }
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
        
        authUseCase.state
            .map { state in
                switch state {
                case .authorized: return FeedFlow()
                case .unauthorized: return MainFlow()
                }
            }.bind(to: rx.coordinator)
            .disposed(by: disposeBag)
        
        return true
    }
}
