// 
// BaseView.swift
// tmsae
// 
// Created by bongzniak on 2022/06/07.
// Copyright 2022 tmsae. All rights reserved.
//

import UIKit

import RxSwift

open class BaseView: UIView {
    
    public var disposeBag = DisposeBag()

    // MARK: Properties

    // MARK: Initializing
    
    public init() {
        super.init(frame: .zero)

        addViews()
        setupViews()
        setupConstraints()
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    deinit {
        logger.verbose("DEINIT: \(String(describing: type(of: self)))")
    }

    open func addViews() {
    }

    open func setupViews() {
    }

    open func setupConstraints() {
    }
}
