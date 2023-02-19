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
    
    // TODO: deinit이 호출되지 않는 문제 임시 처리 - 방법 찾게되면 수정 예정
    private var presentNavigationController: UINavigationController?
    
    public weak var delegate: SaveVocabularyCoordinatorDelegate?
    
    private var editMode: EditMode<Vocabulary>
    
    // MARK: Initializer
    
    public init(
        navigationController: UINavigationController,
        editMode: EditMode<Vocabulary>
    ) {
        self.navigationController = navigationController
        
        self.presentNavigationController = UINavigationController()
        self.presentNavigationController?.modalPresentationStyle = .fullScreen
        
        self.editMode = editMode
    }
    
    public func start() {
        guard let presentNavigationController else { return }
        
        let viewController = SaveVocabularyViewController.instance(
            coordinator: self,
            editMode: editMode
        )
        presentNavigationController.viewControllers = [viewController]
        navigationController.present(presentNavigationController, animated: true)
    }
    
    public func close() {
        presentNavigationController?.dismiss(animated: true) { [weak self] in
            self?.presentNavigationController = nil
        }
    }
    
    public func pushToGroup(with selectedGroup: Group?) {
        guard let presentNavigationController else { return }
        
        let coordinator = GroupsCoordinator(
            navigationController: presentNavigationController,
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
