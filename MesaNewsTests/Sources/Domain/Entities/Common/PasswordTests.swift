//
//  PasswordTests.swift
//  MesaNews Tests
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation
import XCTest
@testable import MesaNews_Dev

class PasswordTests: XCTestCase {
    
    // https://stackoverflow.com/questions/297420/list-of-email-addresses-that-can-be-used-to-test-a-javascript-validation-script/297494#297494
    // https://haacked.com/archive/2007/08/21/i-knew-how-to-validate-an-email-address-until-i.aspx/
    
    func testValidPassword() throws {
        XCTAssertNotNil(Password(from: "123456"))
        XCTAssertNotNil(Password(from: "123456781234567812345678"))
        XCTAssertNotNil(Password(from: "!@#$%ˆ&*("))
        XCTAssertNotNil(Password(from: "asdfghjklqwertyu"))
        
        let nonNilNillablePassword: String? = "asdfghjklqwertyu"
        XCTAssertNotNil(Password(from: nonNilNillablePassword))
        
        let password = Password(from: "qwertyuiop1234567890-!@#$%ˆ&*()+")!
        XCTAssertEqual(password.value, "qwertyuiop1234567890-!@#$%ˆ&*()+")
    }
    
    func testInvalidEmails() throws {
        XCTAssertNil(Password(from: nil))
        XCTAssertNil(Password(from: ""))
        XCTAssertNil(Password(from: "12345"))
        XCTAssertNil(Password(from: "1231231\r2312\n"))
    }
}
