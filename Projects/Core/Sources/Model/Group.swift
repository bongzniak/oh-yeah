//
//  Group.swift
//  Core
//
//  Created by bongzniak on 2023/02/06.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

public struct Group: Hashable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    public init?(groupEntity: GroupEntity?) {
        guard let groupEntity = groupEntity else { return nil }
        
        self.id = groupEntity.id
        self.name = groupEntity.name
    }
}
