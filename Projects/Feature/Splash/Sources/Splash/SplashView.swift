//
//  SplashView.swift
//  Splash
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Core

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
// import ReusableKit
import SnapKit
import Then

final class SplashView: BaseView {
    
    enum Metric {
    }
    
    enum Color {
    }
    
    enum Font {
    }
    
    enum Localized {
    }
    
    // MARK: Properties
    
    let titleLabel: UILabel = UILabel().then {
        $0.text = "title"
    }
    
    // MARK: Initializing
    
    override init() {
        super.init()
        
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    override func setupProperty() {
        super.setupProperty()
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
    
    override func setupBind() {
        super.setupBind()
    }
}

extension SplashView {
    class func instance() -> SplashView {
        SplashView()
    } 
}
