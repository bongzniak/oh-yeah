//
//  VocabularyCoordinator.swift
//  Vocabulary
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import Core

public final class VocabularyCoordinator: Coordinator {
    
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    // MARK: Initializer
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let viewController = VocabularyViewController.instance()
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    public func pushToSaveVocabulary() {
        let coordinator = SaveVocabularyCoordinator(
            navigationController: navigationController
        )
        coordinator.start()
    }
}

private extension VocabularyCoordinator {
    private func getViewController() -> VocabularyViewController {
        return VocabularyViewController.instance().then {
            $0.coordinator = self
        }
    }
}
