//
//  NetworkRequestErrorTest.swift
//  MesaNews-Tests
//
//  Created by Cezar Mauricio on 28/03/21.
//

import XCTest
@testable import MesaNews_Dev

class NetworkRequestErrorTest: XCTestCase {

    let decoder = JSONDecoder()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSingleError() throws {
        let singleOkData = """
        {
          "code": "INVALID_CREDENTIALS",
          "message": "Invalid credentials"
        }
        """.data(using: .utf8)!
        
        let singleSuccess = try! decoder.decode(NetworkRequestError.self, from: singleOkData)
        
        if case .single(let error) = singleSuccess.error {
            XCTAssertEqual(error.code, .invalidCredentials)
            XCTAssertNil(error.field)
            XCTAssertEqual(error.message, "Invalid credentials")
        } else {
            XCTFail("Network request don't produce single error")
        }
    }

    func testMultipleError() throws {
        let multipleData = """
        {
          "errors": [
            {
              "code": "BLANK",
              "field": "password",
              "message": "Password can't be blank"
            },
            {
              "code": "BLANK",
              "field": "password",
              "message": "Password can't be blank"
            },
            {
              "code": "BLANK",
              "field": "name",
              "message": "Name can't be blank"
            },
            {
              "code": "BLANK",
              "field": "email",
              "message": "Email can't be blank"
            },
            {
              "code": "INVALID",
              "field": "email",
              "message": "Email is invalid"
            }
          ]
        }
        """.data(using: .utf8)!

        let multipleSuccess = try! decoder.decode(NetworkRequestError.self, from: multipleData)
        
        if case .multiple(let error) = multipleSuccess.error {
            XCTAssertEqual(error.count, 5)
            
            XCTAssertEqual(error[0].code, .blank)
            XCTAssertEqual(error[0].field, "password")
            XCTAssertEqual(error[0].message, "Password can't be blank")
            
            XCTAssertEqual(error[1].code, .blank)
            XCTAssertEqual(error[1].field, "password")
            XCTAssertEqual(error[1].message, "Password can't be blank")
            
            XCTAssertEqual(error[2].code, .blank)
            XCTAssertEqual(error[2].field, "name")
            XCTAssertEqual(error[2].message, "Name can't be blank")
            
            XCTAssertEqual(error[3].code, .blank)
            XCTAssertEqual(error[3].field, "email")
            XCTAssertEqual(error[3].message, "Email can't be blank")
            
            XCTAssertEqual(error[4].code, .invalid)
            XCTAssertEqual(error[4].field, "email")
            XCTAssertEqual(error[4].message, "Email is invalid")
        } else {
            XCTFail("Network request don't produce multiple error")
        }
    }
}
