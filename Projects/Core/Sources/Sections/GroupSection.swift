//
//  GroupSection.swift
//  Core
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import RxDataSources

public enum GroupSection {
    case section([GroupSectionItem])
}

extension GroupSection: SectionModelType {
    public typealias Item = GroupSectionItem
    public var items: [Item] {
        switch self {
        case .section(let items):
            return items
        }
    }
    
    public init(original: GroupSection, items: [Item]) {
        switch original {
        case .section:
            self = .section((items))
        }
    }
}

public enum GroupSectionItem {
    case group(Group, isSelected: Bool)
    case unknown
}
