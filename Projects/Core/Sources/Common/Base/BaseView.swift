// 
// BaseView.swift
// tmsae
// 
// Created by bongzniak on 2022/06/07.
// Copyright 2022 tmsae. All rights reserved.
//

import UIKit

import RxSwift

/*
 BaseViewController
 - setupProperty()
    - 프로퍼티 관련 - label.font, ...
 - setupDelegate()
    - 델리게이트 패턴 관련 - bodyView.delegate = self, ...
 - setupHierarchy()
    - 계층 관련 - addSubView, ...
 - setupLayout()
    - 레이아웃 관련 - view.snp.makeConstraints, ...
 - setupBind()
    - 바인드 관련 - label.rx.text, ...
 */

protocol BaseViewProtocol {
    func setupProperty()
    func setupDelegate()
    func setupHierarchy()
    func setupLayout()
    func setupBind()
}

open class BaseView: UIView, BaseViewProtocol {
    
    public var disposeBag = DisposeBag()

    // MARK: Properties

    // MARK: Initializing
    
    public init() {
        super.init(frame: .zero)

        setupProperty()
        setupDelegate()
        setupHierarchy()
        setupLayout()
        setupBind()
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    deinit {
        logger.verbose("DEINIT: \(String(describing: type(of: self)))")
    }

    open func setupProperty() {}
    open func setupDelegate() {}
    open func setupHierarchy() {}
    open func setupLayout() {}
    open func setupBind() {}
}
