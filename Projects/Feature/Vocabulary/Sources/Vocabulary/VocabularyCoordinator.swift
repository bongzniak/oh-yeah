//
//  VocabularyCoordinator.swift
//  Vocabulary
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import Core
import Group

protocol BaseVocabularyCoordinator: Coordinator {
    func pushToSaveVocabulary()
    func pushToGroup()
}

// TODO: 네이밍 고민...
// Coordinator <-> Reactor
protocol VocabularyCoordinatorDelegate: AnyObject {
    func selectedGroups(_ groups: [Group])
}

public final class VocabularyCoordinator: BaseCoordinator, BaseVocabularyCoordinator {
    
    public weak var parentCoordinator: Coordinator?
    public var navigationController: UINavigationController
    
    weak var delegate: VocabularyCoordinatorDelegate?
    var rootNavigationController: UINavigationController
    
    // MARK: Initializer
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.rootNavigationController = UINavigationController()
        self.rootNavigationController.modalPresentationStyle = .fullScreen
    }
    
    public func start() {
        let viewController = VocabularyViewController.instance(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func pushToSaveVocabulary() {
        let coordinator = SaveVocabularyCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        
        coordinator.start()
    }
    
    public func pushToGroup() {
        let coordinator = GroupCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.delegate = self

        coordinator.start()
    }
}

extension VocabularyCoordinator: GroupCoordinatorDelegate {
    public func selectedGroups(_ groups: [Core.Group]) {
        delegate?.selectedGroups(groups)
    }
}
