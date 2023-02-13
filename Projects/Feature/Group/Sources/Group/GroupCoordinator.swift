//
//  GroupCoordinator.swift
//  Group
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import UIKit

import Core

protocol BsaeGroupCoordinator: Coordinator {
    func close()
    func presentCreateGroup(
        title: String,
        message: String,
        okTitle: String,
        cancelTitle: String,
        action: @escaping (String) -> Void
    )
}

// Coordinator <-> Coordinator
public protocol GroupCoordinatorDelegate: AnyObject {
    func selectedGroups(_ groups: [Group])
}

public final class GroupCoordinator: BaseCoordinator, BsaeGroupCoordinator {
    
    public weak var parentCoordinator: Coordinator?
    
    public weak var delegate: GroupCoordinatorDelegate?
    
    public var navigationController: UINavigationController
    
    // MARK: Initializer
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let viewController = GroupViewController.instance(
            coordinator: self,
            selectMode: .single,
            selectedIDs: []
        )
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func close() {
        navigationController.popViewController(animated: true)
    }
    
    
    public func close(with groups: [Group]) {
        delegate?.selectedGroups(groups)
        
        close()
    }
    
    public func presentCreateGroup(
        title: String,
        message: String,
        okTitle: String,
        cancelTitle: String,
        action: @escaping (String) -> Void
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addTextField()
        alertController.addAction(
            UIAlertAction(title: okTitle, style: .default) { _ in
                guard let name = alertController.textFields?[0].text,
                      !name.isEmpty else { return }
                action(name)
            }
        )
        alertController.addAction(
            UIAlertAction(title: cancelTitle, style: .cancel)
        )
        
        navigationController.present(alertController, animated: true, completion: nil)
    }
}
