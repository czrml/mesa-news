//
//  SecureStorageService.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation
import RxSwift

protocol SecureStorageService { }

extension SecureStorageService {
    typealias SecureResult<T> = Infallible<T>
}
