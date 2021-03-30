//
//  Repository.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation
import RxSwift

protocol Repository: AnyObject { }

extension Repository {
    typealias RepositoryResult<T> = Infallible<Result<T, DomainError>>
}
