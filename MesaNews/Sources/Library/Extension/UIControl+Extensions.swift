//
//  UIControl+Extensions.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 30/03/21.
//

import Foundation
import UIKit

extension UIControl {
    var isDisabled: Bool {
        get { !isEnabled }
        set { isEnabled = !newValue }
    }
}

extension UIBarItem {
    var isDisabled: Bool {
        get { !isEnabled }
        set { isEnabled = !newValue }
    }
}
