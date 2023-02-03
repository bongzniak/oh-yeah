//
//  BaseNavigationController.swift
//
//  Created by Fernando on 2020/01/05.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit

open class BaseNavigationController: UINavigationController {
    
    // MARK: Properties
    
    // MARK: Initialize
    
    // MARK: Life Cycle
    
    deinit {
        logger.verbose("DEINIT: \(String(describing: type(of: self)))")
    }
}
