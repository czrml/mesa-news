//
//  FeedFlow.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 30/03/21.
//

import Foundation
import UIKit
import RxSwift

final class FeedFlow: FlowCoordinator {
    
    let navigationController: UINavigationController
    
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController = .init()) {
        self.navigationController = navigationController
        navigationController.navigationBar.tintColor = MesaColors.accent.color
        navigationController.navigationBar.barTintColor = MesaColors.primaryBackground.color
        
        showFeedView()
    }
    
    private func showFeedView(){
        let viewModel = DefaultFeedViewModel()
        let view = FeedView(viewModel: viewModel)
        
        navigationController.pushViewController(view, animated: true)
    }
}
