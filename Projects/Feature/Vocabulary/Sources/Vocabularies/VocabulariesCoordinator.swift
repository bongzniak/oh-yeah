//
//  VocabulariesCoordinator.swift
//  Vocabulary
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import Core
import Group

protocol BaseVocabularyCoordinator: Coordinator {
    func pushToSaveVocabulary(editMode: EditMode<Vocabulary>)
    func pushToGroups(with selectedGroup: Group?)
}

// TODO: 네이밍 고민...
// Coordinator <-> Reactor
protocol VocabulariesCoordinatorDelegate: AnyObject {
    func selectedGroups(_ groups: [Group])
}

public final class VocabulariesCoordinator: BaseCoordinator, BaseVocabularyCoordinator {
    
    public weak var parentCoordinator: Coordinator?
    public var navigationController: UINavigationController
    
    weak var delegate: VocabulariesCoordinatorDelegate?
    
    // MARK: Initializer
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let viewController = VocabulariesViewController.instance(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func pushToSaveVocabulary(editMode: EditMode<Vocabulary>) {
        let coordinator = SaveVocabularyCoordinator(
            navigationController: navigationController,
            editMode: editMode
        )
        coordinator.parentCoordinator = self
        
        coordinator.start()
    }
    
    public func pushToGroups(with selectedGroup: Group?) {
        let coordinator = GroupsCoordinator(
            navigationController: navigationController,
            selectMode: .single,
            selectedGroups: [selectedGroup].compactMap { $0 }
        )
        coordinator.parentCoordinator = self
        coordinator.delegate = self

        coordinator.start()
    }
}

extension VocabulariesCoordinator: GroupsCoordinatorDelegate {
    public func selectedGroups(_ groups: [Core.Group]) {
        delegate?.selectedGroups(groups)
    }
}
