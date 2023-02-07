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

final class SaveVocabularyView: BaseView {
    
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
        
        backgroundColor = .blue7
    }
    
    override func setupDelegate() {
        super.setupDelegate()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
    }
    
    override func setupLayout() {
        super.setupLayout()
    }
}

extension SaveVocabularyView {
    class func instance() -> SaveVocabularyView {
        SaveVocabularyView()
    } 
}
