//
//  MesaButton.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 30/03/21.
//

import Foundation
import UIKit

final class MesaButton: UIButton {
    
    private let title: String
    
    var isLoading: Bool = false {
        didSet {
            isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
            isUserInteractionEnabled = !isLoading
            setTitle(isLoading ? "" : title, for: .normal)
        }
    }
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = MesaColors.primaryText.color
        
        return indicator
    }()
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        setTitle(MesaStrings.Login.login, for: .normal)
        setTitleColor(MesaColors.primaryText.color, for: .normal)
        
        backgroundColor = MesaColors.accent.color
        
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(loadingIndicator.snp.height)
            make.centerX.equalToSuperview()
        }
    }
    
    override var isEnabled: Bool {
        didSet { backgroundColor = backgroundColor?.withAlphaComponent(isEnabled ? 1 : 0.5) }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
