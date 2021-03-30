//
//  Password.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

struct Password {
    private let string: String
    
    init?(from string: String) {
        guard !string.isEmpty,
              string.count >= 6
        else { return nil }
        
        let allowedChars = CharacterSet()
            .union(.alphanumerics)
            .union(.punctuationCharacters)
            .union(.symbols)

        let currentChars = CharacterSet(charactersIn: string)
        
        guard currentChars.isSubset(of: allowedChars) else { return nil }
        
        self.string = string
    }
}

extension Password {
    init?(from string: String?) {
        guard let string = string else { return nil }
        self.init(from: string)
    }
}

extension Password: Equatable { }

extension Password {
    var value: String { string }
}
