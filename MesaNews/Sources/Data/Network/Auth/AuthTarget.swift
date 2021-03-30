//
//  AuthTarget.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 27/03/21.
//

import Foundation
import Moya

enum AuthTarget {
    case signin(request: SigninRequest)
    case signup(request: SignupRequest)
}

extension AuthTarget: MesaTargetType {

    var baseURL: URL {
        return URL(string: MesaConfig.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .signin: return "/v1/client/auth/signin"
        case .signup: return "/v1/client/auth/signup"
        }
    }
    
    var method: Method {
        switch self {
        case .signin,
             .signup:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signin(let request):
            return .requestJSONEncodable(request)
        case .signup(let request):
            return .requestJSONEncodable(request)
        }
    }
}
