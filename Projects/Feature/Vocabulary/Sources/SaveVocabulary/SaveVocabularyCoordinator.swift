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


protocol BaseSaveVocabularyCoordinator: Coordinator {
    func pushToGroup(selectMode: SelectMode, selectIDs: Set<String>)
}

public final class SaveVocabularyCoordinator: BaseCoordinator, BaseSaveVocabularyCoordinator {
    
    public weak var parentCoordinator: Coordinator?
    
    public var navigationController: UINavigationController
    
    var rootNavigationController: UINavigationController
    
    // MARK: Initializer
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.rootNavigationController = UINavigationController()
        self.rootNavigationController.modalPresentationStyle = .fullScreen
    }
    
    public func start() {
        let viewController = SaveVocabularyViewController.instance(coordinator: self)
        rootNavigationController.viewControllers = [viewController]
        navigationController.present(rootNavigationController, animated: true)
    }
    
    public func pushToGroup(selectMode: SelectMode, selectIDs: Set<String>) {
        let coordinator = GroupCoordinator(navigationController: rootNavigationController)
        coordinator.parentCoordinator = self
        
        coordinator.start()
    }
}
