//
//  VocabularySection.swift
//  Vocabulary
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import RxDataSources

public enum VocabularySection {
    case section([VocabularySectionItem])
}

extension VocabularySection: SectionModelType {
    public typealias Item = VocabularySectionItem
    public var items: [Item] {
        switch self {
        case .section(let items):
            return items
        }
    }
    
    public init(original: VocabularySection, items: [Item]) {
        switch original {
        case .section:
            self = .section(items)
        }
    }
}

public enum VocabularySectionItem {
    case vocabulary(Vocabulary)
}
