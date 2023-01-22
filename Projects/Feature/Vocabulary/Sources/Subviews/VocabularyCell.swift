//
//  VocabularyCell.swift
//  VocabularyTests
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import Reusable

import Common

final class VocabularyCell: BaseCollectionViewCell, ReactorKit.View, Reusable {
    
    typealias Reactor = VocabularyCellReactor
    
    private enum Metric {
        static let height: CGFloat = 90
    }
    
    private enum Color {
    }
    
    private enum Font {
    }
        
    // MARK: Properties
    
    // MARK: UI Views
    
    let titleLabel: UILabel = UILabel().then {
        $0.text = "titleLabel"
    }
    let descriptionLabel: UILabel = UILabel().then {
        $0.text = "descriptionLabel"
    }
    let groupLabel: UILabel = UILabel().then {
        $0.text = "groupLabel"
    }
    
    // MARK: Initializing
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: UI Setup
    
     override func addViews() {
        super.addViews()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(groupLabel)
    }
    
    override func setupViews() {
        super.setupViews()
        
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .gray
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
        }
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        groupLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    // MARK: Binding
    func bind(reactor: Reactor) {
        
        // Action
        
        // State
        
        // View
    }
}

extension VocabularyCell {
    class func size(width: CGFloat) -> CGSize {
        CGSize(width: width, height: Metric.height)
    }
}
