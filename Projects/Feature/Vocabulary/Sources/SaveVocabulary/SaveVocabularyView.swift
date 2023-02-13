//
//  SaveVocabularyView.swift
//  VocabularyDemoApp
//
//  Created by bongzniak on 2023/02/06.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

import Core
import DesignSystem

final class SaveVocabularyView: BaseView {
    
    // MARK: Constants
    
    private enum Metric {
        static let padding: CGFloat = 12
    }
    
    private enum Color {   
    }
    
    private enum Font {    
    }
    
    private enum Localized {
    }
    
    private enum Configure {
        static let textViewStyle: TextViewStyle = TextViewStyle(
            titleStyle: LabelStyle(font: .bold(ofSize: 16), textColor: .gray8, numberOfLine: 1),
            subtitleStyle: LabelStyle(font: .regular(ofSize: 14), textColor: .gray7, numberOfLine: 1),
            contentStyle: LabelStyle(font: .regular(ofSize: 16), textColor: .gray10),
            placeholderStyle: LabelStyle(font: .regular(ofSize: 15), textColor: .gray5)
        )
    }
    
    // MARK: Properties
    
    // MARK: UI Views
    
    private let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    
    let sectionTitleView = SectionTitleView()
    let spellingTextView = TextViewWithTitle(style: Configure.textViewStyle).then {
        $0.title = "단어"
        $0.placeholder = "단어를 입력해주세요"
        $0.autofocus = true
    }
    let descriptionTextView = TextViewWithTitle(style: Configure.textViewStyle).then {
        $0.title = "의미"
        $0.placeholder = "단어의 의미를 입력해주세요"
    }
    let sentenceTextView = TextViewWithTitle(style: Configure.textViewStyle).then {
        $0.title = "예문"
        $0.subtitle = "옵션"
        $0.placeholder = "단어의 예문을 입력해주세요"
    }
    let searchGuideLabel: UILabel = UILabel().then {
        $0.text = "단어를 입력하고 예문을 찾아보세요"
        $0.font = .regular(ofSize: 10)
        $0.textColor = .gray6
    }
    let searchSententButton: UIButton = UIButton().then {
        $0.configuration?.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        $0.titleLabel?.font = .bold(ofSize: 12)
        $0.setTitle("예문 찾아보기", for: .normal)
        $0.setTitleColor(.blue6, for: .normal)
        $0.setTitleColor(.gray6, for: .disabled)
    }
    
    // MARK: Initializing
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    
    override func setupProperty() {
        super.setupProperty()
        
        backgroundColor = .white
        
        sectionTitleView.title = "단어장을 선택해주세요"
    }
    
    override func setupDelegate() {
        super.setupDelegate()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(sectionTitleView)
        contentView.addSubview(spellingTextView)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(sentenceTextView)
        contentView.addSubview(searchGuideLabel)
        contentView.addSubview(searchSententButton)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        sectionTitleView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(12)
            $0.leading.trailing.equalToSuperview().inset(Metric.padding)
        }
        spellingTextView.snp.makeConstraints {
            $0.top.equalTo(sectionTitleView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(Metric.padding)
        }
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(spellingTextView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(spellingTextView)
        }
        sentenceTextView.snp.makeConstraints {
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(spellingTextView)
        }
        searchGuideLabel.snp.makeConstraints {
            $0.leading.equalTo(sentenceTextView)
            $0.centerY.equalTo(searchSententButton)
        }
        searchSententButton.snp.makeConstraints {
            $0.top.equalTo(sentenceTextView.snp.bottom).offset(4)
            $0.trailing.equalTo(sentenceTextView)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    override public func setupBind() {
        super.setupBind()
    }
}

extension SaveVocabularyView {
    class func instance() -> SaveVocabularyView {
        SaveVocabularyView()
    } 
}
