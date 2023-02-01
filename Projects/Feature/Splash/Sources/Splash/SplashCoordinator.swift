//
//  SplashCoordinator.swift
//  Splash
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import Core

public final class SplashCoordinator: Coordinator {
    
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    // MARK: Initializer
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        navigationController.pushViewController(getViewController(), animated: false)
    }
}

private extension SplashCoordinator {
    func getViewController() -> SplashViewController {
        SplashViewController.instance(navigationController: navigationController)
    }
}
