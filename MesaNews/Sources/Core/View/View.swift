//
//  View.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 30/03/21.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

class View<VM: ViewModel>: UIViewController {
    
    let viewModel: VM
    
    var hidesBackButton: Bool = false { didSet { navigationItem.hidesBackButton = hidesBackButton } }
    
    var keyboardAvoidConstraint: Constraint?
    var keyboardAvoidInvertInset: Bool = false
    var keyboardAvoidBottomInset: CGFloat?
    var keyboardAvoidDefaultOffset: CGFloat?
    var onKeyboardAppears: (() -> Void)?
    
    private var hasBindedView: Bool = false
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        layoutView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("IB not supported")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !hasBindedView {
            bindView()
            hasBindedView = true
        }
    }
    
    /// Used to setup the current view, it's the first function that runs on the init
    func setupView() {
        view.backgroundColor = MesaColors.primaryBackground.color
        edgesForExtendedLayout = []
    }
    
    /// Used to lay out, and configure the view, subviews and static behaviors,
    ///  runs after the view setup and before the ui binding
    func layoutView() { }
    
    /// Used to bind the viewModel data and behavior to the current view, runs after the layout of the view
    func bindView() {
    }
    
    /// Convenience wrapper to add the view to the `UIViewController.view`
    func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }
    /// Convenience wrapper to add the view to the `UIViewController.view` and add SnapKit's contraint maker
    func addSubview(_ view: UIView, constraints: ((ConstraintMaker) -> Void)) {
        self.view.addSubview(view)
        
        view.snp.makeConstraints(constraints)
    }
    
    // MARK: - Disables
    @available(*, unavailable)
    override var navigationController: UINavigationController? {
        get { nil }
        set { _ = newValue }
    }
    
    @available(*, unavailable)
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) { }
    
    @available(*, unavailable)
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) { }

    // MARK: - Keyboard Handling
    @objc private func handleKeyboardNotification(_ notification: Notification) {
        guard let constraint = keyboardAvoidConstraint,
              let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else {
            return
        }
        
        let isShowingKeyboard = notification.name == UIResponder.keyboardWillShowNotification
        let animation = UIView.AnimationOptions(rawValue: animationCurve)
        let bottomInset = keyboardAvoidBottomInset ?? 0
        let defaultOffset = keyboardAvoidDefaultOffset ?? 0
        let avoidSpaceHeight = keyboardFrame.size.height + bottomInset - view.safeAreaInsets.bottom
        let avoidHeight = keyboardAvoidInvertInset ? avoidSpaceHeight * -1 : avoidSpaceHeight
        let offsetHeight = keyboardAvoidInvertInset ? defaultOffset * -1 : defaultOffset
        
        UIView.animate(withDuration: duration, delay: 0, options: [animation], animations: { [weak self] in
            guard let self = self else { return }
            
            constraint.update(offset: isShowingKeyboard ? -avoidHeight : -offsetHeight)
            
            self.view.layoutIfNeeded()
            self.onKeyboardAppears?()
        })
    }
}
