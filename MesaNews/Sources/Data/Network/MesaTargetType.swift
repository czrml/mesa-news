//
//  MesaTargetType.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 27/03/21.
//

import Foundation
import Moya

typealias Method = Moya.Method
typealias Task = Moya.Task

protocol MesaTargetType: TargetType { }

extension MesaTargetType {
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var headers: [String: String]? {
        return nil
    }
}
