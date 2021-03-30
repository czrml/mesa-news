//
//  NetworkService.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation
import RxSwift

protocol NetworkService { }

extension NetworkService {
    typealias NetworkResult<T> = Infallible<Result<T, NetworkError>>
}
