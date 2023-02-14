//
//  BaseViewController.swift
//
//  Created by Fernando on 27/09/2019.
//  Copyright © 2019 tmsae. All rights reserved.
//

import UIKit

import RxSwift

/*
 BaseViewController
 - setupProperty()
    - 프로퍼티 관련 - label.font, ...
 - setupDelegate()
    - 델리게이트 패턴 관련 - bodyView.delegate = self, ...
 */

protocol BaseViewControllerProtocol: AnyObject {
    func setupProperty()
    func setupDelegate()
}

open class BaseViewController: UIViewController, BaseViewControllerProtocol {

    public var disposeBag = DisposeBag()
    
    // MARK: Properties
    
    public var safeAreaInsets: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                let scenes = UIApplication.shared.connectedScenes
                guard let windowScene = scenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else {
                    return self.view.safeAreaInsets
                }
                return window.safeAreaInsets
            } else {
                return .zero
            }
        }
    }
    
    // MARK: Initializing
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        logger.verbose("DEINIT: \(String(describing: type(of: self)))")
    }
    
    // MARK: View Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        setupProperty()
        setupDelegate()
    }
    
    open func setupProperty() {}
    open func setupDelegate() {}
}
