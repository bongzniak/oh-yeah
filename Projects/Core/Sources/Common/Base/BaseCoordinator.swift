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
    var navigationController: UINavigationController { get set }
    
    // MARK: - Methods
    func start()
}
