//
//  Email.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

struct Email {
    private let string: String
    
    init?(from string: String) {
        guard !string.isEmpty,
              string.count < 80,
              let domainKeyIndex = string.firstIndex(of: "@"),
              string[..<domainKeyIndex].count <= 64
        else { return nil }
        
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
            + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
            + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
            + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
            + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
            + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
            + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        guard predicate.evaluate(with: string) else { return nil }
        
        self.string = string
    }
}

extension Email {
    init?(from string: String?) {
        guard let string = string else { return nil }
        self.init(from: string)
    }
}

extension Email: Equatable { }

extension Email {
    var value: String { string }
}
