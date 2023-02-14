//
//  Vocabulary.swift
//  Core
//
//  Created by bongzniak on 2023/02/01.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

public struct Vocabulary: Hashable, Equatable {
    public let id: String
    public let spelling: String
    public let description: String
    public let sentence: String
    public let section: Int
    
    public let starCount: Int
    public var isExpand: Bool = false
    
    public var group: Group?
    
    public init(
        id: String,
        spelling: String,
        description: String,
        sentence: String? = nil,
        group: Group? = nil
    ) {
        self.id = id
        self.spelling = spelling
        self.description = description
        self.sentence = sentence ?? ""
        self.section = 1
        
        self.starCount = 0
        // self.starCount = (0...3).randomElement() ?? 1
        
        self.group = group
    }
    
    public static func == (lhs: Vocabulary, rhs: Vocabulary) -> Bool {
        lhs.id == rhs.id
    }
}
