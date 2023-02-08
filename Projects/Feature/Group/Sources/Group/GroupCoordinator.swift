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

protocol GroupCoordinatorDelegate: AnyObject {
    func createGroup(name: String)
}

public final class GroupCoordinator: Coordinator {
    
    public weak var parentCoordinator: Coordinator?
    
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    weak var delegate: GroupCoordinatorDelegate?
    
    // MARK: Initializer
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let viewController = GroupViewController.instance(
            selectMode: .single,
            selectedIDs: []
        )
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func presentCreateGroup(
        title: String,
        message: String,
        okTitle: String,
        cancelTitle: String
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addTextField()
        let okAction = UIAlertAction(title: okTitle, style: .default) { [weak self] _ in
            guard let name = alertController.textFields?[0].text,
                    !name.isEmpty else { return }
            self?.delegate?.createGroup(name: name)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        navigationController.present(alertController, animated: true, completion: nil)
    }
}