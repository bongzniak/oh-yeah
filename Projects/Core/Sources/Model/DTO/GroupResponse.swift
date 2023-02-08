//
//  GroupResponse.swift
//  Core
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

public struct GroupResponse {
    public let items: [Group]
    public let count: Int
    public let hasNext: Bool
}


public struct GroupFetchPredicate {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
