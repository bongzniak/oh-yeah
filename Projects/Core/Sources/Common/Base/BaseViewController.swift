//
//  BaseViewController.swift
//
//  Created by Fernando on 27/09/2019.
//  Copyright © 2019 tmsae. All rights reserved.
//

import UIKit

import RxSwift


open class BaseViewController: UIViewController {

    public var disposeBag = DisposeBag()
    
    // MARK: Properties
    
    var safeAreaInsets: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                guard let window = UIApplication.shared.windows.first else {
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

        addViews()
        setupViews()
    }
    
    open func addViews() {
        
    }

    open func setupViews() {
        
    }
}
