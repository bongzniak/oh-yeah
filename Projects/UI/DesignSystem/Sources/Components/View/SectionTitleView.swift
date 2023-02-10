//
//  SectionTitleView.swift
//  DesignSystem
//
//  Created by bongzniak on 2023/02/10.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

import Core

public final class SectionTitleView: BaseView {
    
    // MARK: Constants
    
    private enum Metric {
        static let height: CGFloat = .zero
    }
    
    private enum Color {
    }
    
    private enum Font {
    }
    
    private enum Image {
        static let chevronRight = UIImage(systemName: "chevron.forward")?
            .withTintColor(.gray8, renderingMode: .alwaysOriginal)
    }
        
    // MARK: Properties
    
    let titleStyle: LabelStyle
    let subtitleStyle: LabelStyle
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    // MARK: UI Views
    
    let stackView: UIStackView = UIStackView().then {
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let moreImageView = UIImageView().then {
        $0.image = Image.chevronRight
    }
    let button = UIButton()
    
    // MARK: Initializing
    
    public init(
        titleStyle: LabelStyle = LabelStyle(font: .bold(ofSize: 14), textColor: .gray10),
        subtitleStyle: LabelStyle = LabelStyle(font: .regular(ofSize: 14), textColor: .gray8)
    ) {
        self.titleStyle = titleStyle
        self.subtitleStyle = subtitleStyle
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    
    public override func setupProperty() {
        super.setupProperty()
        
        titleLabel.font = titleStyle.font
        titleLabel.textColor = titleStyle.textColor
        
        subtitleLabel.font = subtitleStyle.font
        subtitleLabel.textColor = subtitleStyle.textColor
    }
    
    public override func setupDelegate() {
        super.setupDelegate()
    }
    
    public override func setupHierarchy() {
        super.setupHierarchy()

        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(moreImageView)
        
        addSubview(stackView)
        addSubview(button)
    }
    
    public override func setupLayout() {
        super.setupLayout()
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.edges.equalTo(stackView)
        }
    }

    public override func setupBind() {
        super.setupBind()
    }
}

extension Reactive where Base: SectionTitleView {
    public var title: Binder<String> {
        return Binder(self.base) { base, title in
            base.titleLabel.text = title
        }
    }

    public var subtitle: Binder<String> {
        return Binder(self.base) { base, text in
            base.subtitleLabel.text = text
        }
    }
    
    public var throttleTap: Observable<Void> {
        return base.button.rx.throttleTap
    }
}






