//
//  BaseReactor.swift
//  Core
//
//  Created by bongzniak on 2023/02/09.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

open class BaseReactor {
    deinit {
        logger.verbose("DEINIT: \(String(describing: type(of: self)))")
    }
    
    public init() {
        
    }
}
