//
//  VocabularyRequest.swift
//  Core
//
//  Created by bongzniak on 2023/02/07.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

public struct VocabularyRequest {
    public let groupID: String
    
    public let vocabularyID: String
    public let spelling: String
    public let description: String
    public let sentence: String
    
    public init(
        groupID: String,
        vocabularyID: String,
        spelling: String,
        description: String,
        sentence: String
    ) {
        self.groupID = groupID
        self.vocabularyID = vocabularyID
        self.spelling = spelling
        self.description = description
        self.sentence = sentence
    }
}
