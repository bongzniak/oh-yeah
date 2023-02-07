//
//  Vocabulary.swift
//  Core
//
//  Created by bongzniak on 2023/02/01.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

public struct Vocabulary: Hashable, Equatable {
    public let group: String
    public let section: String
    
    public let spelling: String
    public let description: String
    public let sentence: String
    
    public let starCount: Int
    
    public var isExpand: Bool = false
    
    public init(
        spelling: String,
        description: String
    ) {
        self.group = "필수 영단어 100"
        self.section = "chapter 01"
        
        self.spelling = spelling
        self.description = description
        self.sentence = "He risked his life to save her."
        self.starCount = (0...3).randomElement() ?? 1
    }
    
    public static func == (lhs: Vocabulary, rhs: Vocabulary) -> Bool {
        lhs.spelling == rhs.spelling
    }
}
