//
//  VocabularySection.swift
//  Vocabulary
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import RxDataSources

enum VocabularySection {
    case section([VocabularySectionItem])
}

extension VocabularySection: SectionModelType {
    typealias Item = VocabularySectionItem
    var items: [Item] {
        switch self {
        case .section(let items):
            return items
        }
    }
    
    init(original: VocabularySection, items: [Item]) {
        switch original {
        case .section:
            self = .section(items)
        }
    }
}

enum VocabularySectionItem {
    case voca
}
