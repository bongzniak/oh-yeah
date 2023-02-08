//
//  PlachholderTextView.swift
//  DesignSystem
//
//  Created by bongzniak on 2023/02/07.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

import Core

public final class BaseTextView: UITextView {
    
    // MARK: Rx
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Constants
    
    public let textViewHeight = PublishRelay<CGFloat>()
    
    // MARK: Properties
    
    public var placeholder: String? {
        didSet {
            self.placeholderLabel.text = placeholder
        }
    }
    public var placeholderColor: UIColor? {
        didSet {
            self.placeholderLabel.textColor = placeholderColor
        }
    }
    public var placeholderFont: UIFont? {
        didSet {
            self.placeholderLabel.font = placeholderFont ?? .regular(ofSize: 14)
        }
    }
    
    public  override var text: String! {
        didSet {
            self.placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    // MARK: UI Views
    
    private let placeholderLabel: UILabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    // MARK: Initializing
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.setupProperty()
        self.setupDelegate()
        self.setupHierarchy()
        self.setupLayout()
        self.setupBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        logger.verbose("DEINIT: \(String(describing: type(of: self)))")
    }
    
    // MARK: UI Setup
    
    private func setupProperty() {
    }
    
    private func setupDelegate() {
    }
    
    private func setupHierarchy() {
        addSubview(placeholderLabel)
    }
    
    private func setupLayout() {
        placeholderLabel.snp.makeConstraints {
            $0.centerY.equalTo(textInputView)
            $0.leading.equalTo(textContainerInset.left).offset(2)
        }
    }

    private func setupBind() {
        rx.didBeginEditing.map { !self.text.isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
            .drive(placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        rx.didChange.map { !self.text.isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
            .drive(placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
