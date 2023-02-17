//
//  TextViewWithTitleView.swift
//  DesignSystem
//
//  Created by bongzniak on 2023/02/06.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

import Core

public struct TextViewStyle {
    var titleStyle: LabelStyle
    var subtitleStyle: LabelStyle
    var contentStyle: LabelStyle
    var placeholderStyle: LabelStyle
    
    public init(
        titleStyle: LabelStyle,
        subtitleStyle: LabelStyle,
        contentStyle: LabelStyle,
        placeholderStyle: LabelStyle
    ) {
        self.titleStyle = titleStyle
        self.subtitleStyle = subtitleStyle
        self.contentStyle = contentStyle
        self.placeholderStyle = placeholderStyle
    }
}

public final class TextViewWithTitle: BaseView {
    
    // MARK: Constants
    
    private enum Metric {
        static let height: CGFloat = .zero
    }
    
    private enum Color {
    }
    
    private enum Font {
    }
        
    // MARK: Properties
    
    private let style: TextViewStyle
    
    public var title: String? {
        didSet { self.titleLabel.text = title }
    }
    public var subtitle: String? {
        didSet { self.subtitleLabel.text = subtitle }
    }
    public var placeholder: String? {
        didSet { self.textView.placeholder = placeholder }
    }
    
    public var autofocus: Bool? {
        didSet {
            if let autofocus, autofocus {
                self.textView.becomeFirstResponder()
            }
        }
    }
    
    public var text: String {
        self.textView.text
    }
    
    // MARK: UI Views
    
    let titleLabel: UILabel = UILabel()
    let subtitleLabel: UILabel = UILabel()
    let textView: BaseTextView = BaseTextView(frame: .zero).then {
        $0.backgroundColor = .blue2
        $0.layer.cornerRadius = 8
        $0.contentInset = UIEdgeInsets(6)
    }
    
    // MARK: Initializing
    
    public init(style: TextViewStyle) {
        self.style = style
        
        super.init()
        
        setupBind()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    public override func setupProperty() {
        super.setupProperty()
        
        titleLabel.font = style.titleStyle.font
        titleLabel.textColor = style.titleStyle.textColor
        
        subtitleLabel.font = style.subtitleStyle.font
        subtitleLabel.textColor = style.subtitleStyle.textColor

        textView.font = style.contentStyle.font
        textView.textColor = style.contentStyle.textColor
        textView.placeholderColor = style.placeholderStyle.textColor
    }
    
    public override func setupDelegate() {
        super.setupDelegate()
    }
    
    public override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(textView)
    }
    
    public override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    override public func setupBind() {
        super.setupBind()
        
        textView.rx.text
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.textView.text = text
            }
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: TextViewWithTitle {
    public var text: ControlProperty<String?> {
        base.textView.rx.text
    }
}
