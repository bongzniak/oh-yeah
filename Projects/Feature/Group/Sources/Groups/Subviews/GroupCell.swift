//
//  GroupCell.swift
//  Group
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import Reusable

import Core
import DesignSystem

final class GroupCell: BaseCollectionViewCell, View, Reusable {
    
    typealias Reactor = GroupCellReactor
    
    // MARK: Constants
    
    private enum Metric {
        static let height: CGFloat = 60
    }
    
    private enum Color {
        static let nameLabel: UIColor = .gray8
    }
    
    private enum Font {
        static let nameLabel: UIFont = .regular(ofSize: 16)
    }
    
    private enum Localized {
        static let unknownGroup: String = "그룹 미지정"
    }
        
    // MARK: Properties
    
    // MARK: UI Views
    
    let nameLabel: UILabel = UILabel().then {
        $0.font = Font.nameLabel
        $0.textColor = Color.nameLabel
    }
    let countLabel: UILabel = UILabel().then {
        $0.font = Font.nameLabel
        $0.textColor = Color.nameLabel
    }
    
    // MARK: Initializing
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: UI Setup
    
    override func setupProperty() {
        super.setupProperty()
        
        contentView.backgroundColor = .gray4
        contentView.layer.cornerRadius = 8
    }
    
    override func setupDelegate() {
        super.setupDelegate()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
        }
        countLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
        }
    }
    
    // MARK: Binding
    
    func bind(reactor: Reactor) {
        bindState(reactor: reactor)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map { $0.name ?? Localized.unknownGroup }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { "단어 \($0.totlaCount)개" }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSelected }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .map { isSelected -> UIColor in
                isSelected ? .blue3 : .gray3
            }
            .drive(contentView.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}

extension GroupCell {
    class func size(width: CGFloat) -> CGSize {
        CGSize(width: width, height: Metric.height)
    }
}
