//
//  SplashView.swift
//  Splash
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Common

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
    
    // MARK: Initializing
    
    override init() {
        super.init()
        
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    override func addViews() {
        super.addViews()
    }
    
    override func setupViews() {
        super.setupViews()
    }

    override func setupConstraints() {
        super.setupConstraints()
    }
}

extension SplashView {
    class func instance() -> SplashView {
        SplashView()
    } 
}
