//
//  BaseCoordinator.swift
//  appname
//
//  Created by bongzniak on 2023/01/17.
//  Copyright © 2023 tmsae. All rights reserved.
//

import UIKit

/// Protocol that all coordinator must be conform
public protocol Coordinator: AnyObject {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    // MARK: - Methods
    func start()
    func addChild(_ child: Coordinator)
}

// MARK: - Default Implementation
public extension Coordinator {
    func addChild(_ child: Coordinator) {
        childCoordinators.append(child)
    }
}
