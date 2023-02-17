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
    func pushToGroup(with selectedGroup: Group?)
    func close()
}

// Coordinator <-> Reactor
public protocol SaveVocabularyCoordinatorDelegate: AnyObject {
    func selectedGroups(_ groups: [Group])
}

public final class SaveVocabularyCoordinator: BaseCoordinator, BaseSaveVocabularyCoordinator {
    
    public weak var parentCoordinator: Coordinator?
    public var navigationController: UINavigationController
    
    public weak var delegate: SaveVocabularyCoordinatorDelegate?
    var rootNavigationController: UINavigationController
    
    private var editMode: EditMode<Vocabulary>
    
    // MARK: Initializer
    
    public init(
        navigationController: UINavigationController,
        editMode: EditMode<Vocabulary>
    ) {
        self.navigationController = navigationController
        
        self.rootNavigationController = UINavigationController()
        self.rootNavigationController.modalPresentationStyle = .fullScreen
        
        self.editMode = editMode
    }
    
    public func start() {
        let viewController = SaveVocabularyViewController.instance(
            coordinator: self,
            editMode: editMode
        )
        rootNavigationController.viewControllers = [viewController]
        navigationController.present(rootNavigationController, animated: true)
    }
    
    public func close() {
        navigationController.dismiss(animated: true)
    }
    
    public func pushToGroup(with selectedGroup: Group?) {
        let coordinator = GroupsCoordinator(
            navigationController: rootNavigationController,
            selectMode: .single,
            selectedGroups: [selectedGroup].compactMap { $0 }
        )
        coordinator.parentCoordinator = self
        coordinator.delegate = self
        
        coordinator.start()
    }
}

extension SaveVocabularyCoordinator: GroupsCoordinatorDelegate {
    public func selectedGroups(_ groups: [Group]) {
        delegate?.selectedGroups(groups)
    }
}
