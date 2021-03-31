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
        
        let newsRepository = Resolver.optional(NewsRepository.self)
        XCTAssertNotNil(newsRepository, "News Repository was not registered")
    }
    
    func testUseCasesInjection() throws {
        let authUseCase = Resolver.optional(AuthUseCase.self)
        XCTAssertNotNil(authUseCase, "Auth UseCase was not registered")
        
        let loginUseCase = Resolver.optional(LoginUseCase.self)
        XCTAssertNotNil(loginUseCase, "Login UseCase was not registered")
        
        let signupUseCase = Resolver.optional(SignupUseCase.self)
        XCTAssertNotNil(signupUseCase, "Signup UseCase was not registered")
        
        
        let getAuthorizationUseCase = Resolver.optional(GetAuthorizationUseCase.self)
        XCTAssertNotNil(getAuthorizationUseCase, "Get Authorization UseCase was not registered")
        
        let saveAuthorizationUseCase = Resolver.optional(SaveAuthorizationUseCase.self)
        XCTAssertNotNil(saveAuthorizationUseCase, "Save authorization UseCase was not registered")
        
        let deleteAuthorizationUsecase = Resolver.optional(DeleteAuthorizationUseCase.self)
        XCTAssertNotNil(deleteAuthorizationUsecase, "Delete authentication UseCase was not registered")
        
        let getNewsUseCase = Resolver.optional(GetNewsUseCase.self)
        XCTAssertNotNil(getNewsUseCase, "GetNews UseCase was not registered")
        
        let getHighlightsUseCase = Resolver.optional(GetHighlightsUseCase.self)
        XCTAssertNotNil(getHighlightsUseCase, "GetHighlights UseCase was not registered")
    }
        
    func testServicesInjection() throws {
        let authSecureStorageService = Resolver.optional(AuthSecureStorageService.self)
        XCTAssertNotNil(authSecureStorageService, "AuthSecureStorage Service was not registered")
        
        let authNetworkService = Resolver.optional(AuthNetworkService.self)
        XCTAssertNotNil(authNetworkService, "AuthNetwork Service was not registered")
        
        let newsNetworkService = Resolver.optional(NewsNetworkService.self)
        XCTAssertNotNil(newsNetworkService, "NewsNetwork Service was not registered")
    }
}
