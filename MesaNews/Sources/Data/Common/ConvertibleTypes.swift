//
//  ConvertibleTypes.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 30/03/21.
//

import Foundation

protocol DataConvertibleType {
    associatedtype DomainType
    init(from domain: DomainType)
}

protocol DomainConvertibleType {
    associatedtype DomainType
    var asDomain: DomainType? { get }
}
