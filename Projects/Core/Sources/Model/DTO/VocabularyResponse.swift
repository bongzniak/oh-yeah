//
//  VocabularyResponse.swift
//  Core
//
//  Created by bongzniak on 2023/02/06.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

public struct VocabularyResponse {
    public let items: [Vocabulary]
    public let count: Int
    public let hasNext: Bool
}

public struct VocabularyFetchPredicate {
    public let groupID: String
    public let section: Int?
    
    public init(groupID: String, section: Int? = nil) {
        self.groupID = groupID
        self.section = section
    }
}

