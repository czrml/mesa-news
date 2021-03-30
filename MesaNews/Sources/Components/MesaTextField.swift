//
//  MesaTextField.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 30/03/21.
//

import Foundation
import UIKit

final class MesaTextField: UITextField, UITextFieldDelegate {
    
    private let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        
        backgroundColor = MesaColors.secondaryBackground.color
        textColor = MesaColors.secondaryText.color
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: MesaColors.secondaryText.color.withAlphaComponent(0.5)
        ]
        
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: placeholderAttributes)
        
        delegate = self
        
    }
    
    override var isEnabled: Bool { didSet { alpha = isEnabled ? 1 : 0.75 } }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
