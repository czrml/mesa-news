//
//  EmailTests.swift
//  sudo
//
//  Created by Cezar Mauricio on 02/03/21.
//

import Foundation
import XCTest
@testable import MesaNews_Dev

class EmailTests: XCTestCase {
    
    // https://stackoverflow.com/questions/297420/list-of-email-addresses-that-can-be-used-to-test-a-javascript-validation-script/297494#297494
    // https://haacked.com/archive/2007/08/21/i-knew-how-to-validate-an-email-address-until-i.aspx/
    
    func testValidEmail() throws {
        XCTAssertNotNil(Email(from: "simple@example.com"), "a valid email")
        
        XCTAssertNotNil(Email(from: "very.common@example.com"), "a valid email")
        
        XCTAssertNotNil(Email(from: "disposable.style.email.with+symbol@example.com"), "a valid email")
        
        XCTAssertNotNil(Email(from: "other.email-with-hyphen@example.com"), "a valid email")
        
        XCTAssertNotNil(Email(from: "fully-qualified-domain@example.com"), "a valid email")
        
        XCTAssertNotNil(Email(from: "user.name+tag+sorting@example.com"), "may go to user.name@example.com inbox depending on mail server")
        
        XCTAssertNotNil(Email(from: "x@example.com"), "one-letter local-part")
        
        XCTAssertNotNil(Email(from: "example-indeed@strange-example.com"), "a valid email")
                
        XCTAssertNotNil(Email(from: "example@s.example"), "see the List of Internet top-level domains")
        
        XCTAssertNotNil(Email(from: "\"john..doe\"@example.org"), "quoted double dot")
        
        XCTAssertNotNil(Email(from: "mailhost!username@example.org"), "bangified host route used for uucp mailers")
        
        XCTAssertNotNil(Email(from: "user%example.com@example.org"), "% escaped mail route to user@example.com via example.org")
        
        XCTAssertNotNil(Email(from: "user-@example.org"), "local part ending with non-alphanumeric character from the list of allowed printable characters")
        
        XCTAssertNotNil(Email(from: ##"me@example.com"##), "A valid email")
        
        XCTAssertNotNil(Email(from: ##"a.nonymous@example.com"##), "A valid email")
        
        XCTAssertNotNil(Email(from: ##"name+tag@example.com"##), "A valid email")
        
        XCTAssertNotNil(Email(from: ##"customer/department@example.com"##), "A valid email")
        
        XCTAssertNotNil(Email(from: ##"$A12345@example.com"##), "A valid email")
        
        XCTAssertNotNil(Email(from: ##"!def!xyz%abc@example.com"##), "A valid email")
        
        XCTAssertNotNil(Email(from: ##"_Yosemite.Sam@example.com"##), "A valid email")
        
        XCTAssertNotNil(Email(from: ##"~@example.com"##), "A valid email")
        
        XCTAssertNotNil(Email(from: ##"Ima.Fool@example.com"##), "A valid email")
    }
    
    func testInvalidEmails() throws {
        XCTAssertNil(Email(from: nil), "A nil email")
        
        XCTAssertNil(Email(from: ##"Abc.example.com"##), "no @ character)")
        
        XCTAssertNil(Email(from: ##"A@b@c@example.com"##), "only one @ is allowed outside quotation marks)")
        
        XCTAssertNil(Email(from: ##"a\"b(c)d,e:f;g<h>i[j\k]l@example.com"##), "none of the special characters in this local-part are allowed outside quotation marks)")
        
        XCTAssertNil(Email(from: ##"just\"not"right@example.com"##), "quoted strings must be dot separated or the only element making up the local-part)")
        
        XCTAssertNil(Email(from: ##"this is\"not\allowed@example.com"##), "spaces, quotes, and backslashes may only exist when within quoted strings and preceded by a backslash)")
        
        XCTAssertNil(Email(from: ##"this\ still\"not\\allowed@example.com"##), "even if escaped (preceded by a backslash), spaces, quotes, and backslashes must still be contained by quotes)")
        
        XCTAssertNil(Email(from: ##"1234567890123456789012345678901234567890123456789012345678901234+x@example.com"##), "local-part is longer than 64 characters)")
        
        XCTAssertNil(Email(from: ##"i_like_underscore@but_its_not_allowed_in_this_part.example.com"##), "Underscore is not allowed in domain part)")
        
        XCTAssertNil(Email(from: ##"me@"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"@example.com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"me.@example.com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##".me@example.com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"me@example..com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"me.example@com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"me\@example.com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"NotAnEmail"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"@NotAnEmail"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"\"\"test\blah""@example.com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"\"test\rblah\"@example.com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"\"\"test""blah""@example.com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##".wooly@example.com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"wo..oly@example.com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"pootietang.@example.com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##".@example.com"##), "An invalid email")
        
        XCTAssertNil(Email(from: ##"Ima Fool@example.com"##), "An invalid email")
    }
}
