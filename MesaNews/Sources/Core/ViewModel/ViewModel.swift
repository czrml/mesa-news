//
//  ViewModel.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation
import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func map(input: Input) -> Output
    
    associatedtype ActionValueUpdate
    associatedtype DelegateAction
    
    var onDelegatedAction: Observable<DelegateAction> { get }
    func update(value: ActionValueUpdate)
    func delegate(action: DelegateAction)
}

extension ViewModel {
    var onDelegatedAction: Observable<Void> { .never() }
    func update(value: Void) { }
    func delegate(action: Void) { }
}
