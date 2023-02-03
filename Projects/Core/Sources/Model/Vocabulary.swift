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
        
        self.starCount = 4
    }
    
    public static func random() -> Vocabulary {
        [
            Vocabulary(spelling: "appleappleappleappleappleappleappleappleapple", description: "사과"),
            Vocabulary(spelling: "provider", description: "공급하다 appleappleap pleapple appleapple appleappleapple"),
            Vocabulary(spelling: "save", description: "저장하다"),
            Vocabulary(spelling: "book", description: "책"),
            Vocabulary(spelling: "cup", description: "컵"),
            Vocabulary(spelling: "design", description: "디자인"),
        ]
            .randomElement() ?? Vocabulary(spelling: "", description: "")
    }
    
    public static func ==(lhs: Vocabulary, rhs: Vocabulary) -> Bool {
        lhs.spelling == rhs.spelling
    }
}
