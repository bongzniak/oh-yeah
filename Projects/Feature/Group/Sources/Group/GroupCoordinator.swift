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

protocol BsaeGroupCoordinator: Coordinator {
    func close()
    func presentCreateGroup(title: String, message: String, okTitle: String, cancelTitle: String)
}

public final class GroupCoordinator: BaseCoordinator, BsaeGroupCoordinator {
    
    public weak var parentCoordinator: Coordinator?
    
    public var navigationController: UINavigationController
    
    weak var delegate: GroupCoordinatorDelegate?
    
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
        alertController.addAction(
            UIAlertAction(title: okTitle, style: .default) { [weak self] _ in
                guard let name = alertController.textFields?[0].text,
                      !name.isEmpty else { return }
                self?.delegate?.createGroup(name: name)
            }
        )
        alertController.addAction(
            UIAlertAction(title: cancelTitle, style: .cancel)
        )
        
        navigationController.present(alertController, animated: true, completion: nil)
    }
}
