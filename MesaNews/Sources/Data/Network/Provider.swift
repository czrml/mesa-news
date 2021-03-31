//
//  Provider.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 27/03/21.
//

import Foundation
import Moya
import RxSwift

protocol MesaProviderType: AnyObject {
    associatedtype Target: MesaTargetType

    func request<T: Decodable>(_ token: Target) -> Infallible<Result<T, NetworkError>>
}

final class MesaProvider<Target>: MesaProviderType where Target: MesaTargetType {
    
    private let disposeBag = DisposeBag()
    
    @Injected private var authUseCase: AuthSecureStorageService
    
    private lazy var authPlugin = AuthPlugin(tokenClosure: { [weak self] in self?.authUseCase.token })
    private lazy var provider = MoyaProvider<Target>(plugins: [authPlugin])

    func request<T: Decodable>(_ token: Target) -> Infallible<Result<T, NetworkError>> {
        return Infallible.create { [weak self] infallible in
            guard let self = self else { return Disposables.create() }
                
            let cancellable = self.provider.request(token) { result in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder()

                    guard 200...399 ~= response.statusCode else {
                        guard let requestError = try? decoder.decode(NetworkRequestError.self, from: response.data)
                        else {
                            guard let networkError = NetworkError(from: response.statusCode) else {
                                return infallible(.next(.failure(.unknown)))
                            }
                            return infallible(.next(.failure(networkError)))
                        }
                        return infallible(.next(.failure(.request(requestError))))
                    }
                    
                    do {
                        let decodedResponse = try decoder.decode(T.self, from: response.data)
                        infallible(.next(.success(decodedResponse)))
                    } catch let error {
                        print(error)
                        infallible(.next(.failure(.serverError)))
                    }
                case .failure:
                    infallible(.next(.failure(.unknown)))
                }
            }
            
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}

struct AuthPlugin: PluginType {
  let tokenClosure: () -> String?

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    guard let token = tokenClosure() else {
      return request
    }
    
    var request = request
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    return request
  }
}
