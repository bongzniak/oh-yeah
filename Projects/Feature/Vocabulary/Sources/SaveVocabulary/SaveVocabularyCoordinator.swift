//
//  SaveVocabularyCoordinator.swift
//  VocabularyDemoApp
//
//  Created by bongzniak on 2023/02/06.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import UIKit

import Core
import Group

public final class SaveVocabularyCoordinator: Coordinator {
    
    public weak var parentCoordinator: Coordinator?
    
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    // MARK: Initializer
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        logger.verbose("DEINIT: \(String(describing: type(of: self)))")
    }
    
    public func start() {
        let viewController = SaveVocabularyViewController.instance(coordinator: self)
        navigationController.present(
            UINavigationController(rootViewController: viewController),
            animated: true
        )
    }
    
    public func pushToGroup(selectMode: SelectMode, selectIDs: Set<String>) {
        let coordinator = GroupCoordinator(navigationController: self.navigationController)
        coordinator.parentCoordinator = self
        
        coordinator.start()
    }
}
