//
//  InjectedTests.swift
//  MesaNews Tests
//
//  Created by Cezar Mauricio on 29/03/21.
//

import XCTest
import Resolver
@testable import MesaNews_Dev

class InjectedTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRepositoriesInjection() throws {
        let authRepository = Resolver.optional(AuthRepository.self)
        XCTAssertNotNil(authRepository, "Auth Repository was not registered")
    }
    
    func testUseCasesInjection() throws {
        let authUseCase = Resolver.optional(AuthUseCase.self)
        XCTAssertNotNil(authUseCase, "Auth UseCase was not registered")
        
        let loginUseCase = Resolver.optional(LoginUseCase.self)
        XCTAssertNotNil(loginUseCase, "Login UseCase was not registered")
        
        let signupUseCase = Resolver.optional(SignupUseCase.self)
        XCTAssertNotNil(signupUseCase, "Signup UseCase was not registered")
    }
        
    func testServicesInjection() throws {
        let authNetworkService = Resolver.optional(AuthNetworkService.self)
        XCTAssertNotNil(authNetworkService, "AuthNetwork Service was not registered")
        
    }
}
