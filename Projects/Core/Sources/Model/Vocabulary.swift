//
//  Vocabulary.swift
//  Core
//
//  Created by bongzniak on 2023/02/01.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

public struct Vocabulary: Hashable {
    public let spelling: String
    public let description: String
    public let sentence: String
    public let starCount: Int
    
    public init(
        spelling: String,
        description: String,
        sentence: String
    ) {
        self.spelling = spelling
        self.description = description
        self.sentence = sentence
        self.starCount = 4
    }
    
    init(
        spelling: String,
        description: String
    ) {
        self.init(spelling: spelling, description: description, sentence: "asdasdasdasd")
    }
    
    public static func random() -> Vocabulary {
        [
            Vocabulary(spelling: "apple", description: "사과"),
            Vocabulary(spelling: "provider", description: "공급하다"),
            Vocabulary(spelling: "save", description: "저장하다"),
            Vocabulary(spelling: "book", description: "책"),
            Vocabulary(spelling: "cup", description: "컵"),
            Vocabulary(spelling: "design", description: "디자인"),
        ]
            .randomElement() ?? Vocabulary(spelling: "", description: "")
    }
}
