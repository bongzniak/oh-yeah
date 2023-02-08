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
    
    public func start() {
        let viewController = SaveVocabularyViewController.instance()
        viewController.coordinator = self
        
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.modalPresentationStyle = .fullScreen
        
        navigationController.present(navigation, animated: true)
    }
    
    public func pushToGroup(selectMode: SelectMode, selectIDs: Set<String>) {
        let coordinator = GroupCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        addChild(coordinator)
        
        coordinator.start()
    }
}
