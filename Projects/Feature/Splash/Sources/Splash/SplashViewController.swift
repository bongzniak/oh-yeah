//
//  SplashViewController.swift
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

final class SplashViewController:
    BaseViewController, ReactorKit.View {
    
    typealias Reactor = SplashViewReactor
    
    private enum Metric {
        
    }
    
    private enum Color {
        
    }
    
    private enum Font {
        
    }
    
    private enum Localized {
        
    }
    
    // MARK: Properties

    // MARK: UI
    
    let bodyView: SplashView
    
    // MARK: Initializing
    
    init(
        reactor: Reactor,
        bodyView: SplashView
    ) {
        defer {
            self.reactor = reactor
        }
        
        self.bodyView = bodyView
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func loadView() {
        super.loadView()

        view = bodyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Binding
    
    func bind(reactor: SplashViewReactor) {

        // Action
        
    }
}

extension SplashViewController {
    class func instance(navigationController: UINavigationController) -> SplashViewController {
        return SplashViewController(
            reactor: SplashViewReactor(
                splashCoordinator: SplashCoordinator(navigationController: navigationController)
            ),
            bodyView: SplashView.instance()
        )
    }
}
