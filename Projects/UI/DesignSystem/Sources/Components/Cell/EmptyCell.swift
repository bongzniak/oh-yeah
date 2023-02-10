//
//  EmptyCell.swift
//  DesignSystem
//
//  Created by bongzniak on 2023/02/09.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then
import Reusable

import Core

public final class EmptyCell: BaseCollectionViewCell, Reusable {
    
    // MARK: Constants
    
    private enum Metric {
    }
    
    private enum Color {
    }
    
    private enum Font {
    }
    
    private enum Localized {
    }
        
    // MARK: Properties
    
    // MARK: UI Views
    
    let stackView: UIStackView = UIStackView().then {
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = 8
    }
    let titleLabel = UILabel().then {
        $0.text = "비어있는 화면이에요."
    }
    let subtitleLabel = UILabel().then  {
        $0.text = "새로운 정보를 추가하여 사용해보세요"
    }
    
    // MARK: Initializing
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: UI Setup
    
    public override func setupProperty() {
        super.setupProperty()
    }
    
    public override func setupDelegate() {
        super.setupDelegate()
    }
    
    public override func setupHierarchy() {
        super.setupHierarchy()
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        contentView.addSubview(stackView)
    }
    
    public override func setupLayout() {
        super.setupLayout()
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(12)
            $0.trailing.lessThanOrEqualToSuperview().inset(12)
        }
    }
    
    public override func setupBind() {
        super.setupLayout()
    }
}

extension EmptyCell {
    public class func size(width: CGFloat, height: CGFloat) -> CGSize {
        CGSize(width: width, height: height)
    }
}
