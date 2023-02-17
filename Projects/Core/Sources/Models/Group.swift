//
//  Group.swift
//  Core
//
//  Created by bongzniak on 2023/02/06.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

public struct Group: Codable, Hashable, Equatable {
    public let id: String
    public let name: String
    public let count: Int
    
    public init(id: String, name: String, count: Int) {
        self.id = id
        self.name = name
        self.count = count
    }
    
    public init?(groupEntity: GroupEntity?) {
        guard let groupEntity = groupEntity else { return nil }
        
        self.id = groupEntity.id
        self.name = groupEntity.name
        self.count = 0
    }
    
    public static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.id == rhs.id
    }
}
