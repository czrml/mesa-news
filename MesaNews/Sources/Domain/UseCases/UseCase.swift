//
//  UseCase.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 29/03/21.
//

import Foundation
import RxSwift

protocol UseCase: AnyObject { }

extension UseCase {
    typealias UseCaseResultType<T> = Result<T, DomainError>
    typealias UseCaseResult<T> = Infallible<UseCaseResultType<T>>
}
