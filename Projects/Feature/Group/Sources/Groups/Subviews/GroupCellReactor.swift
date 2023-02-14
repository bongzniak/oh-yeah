//
//  GroupCellReactor.swift
//  Group
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

import Core

class GroupCellReactor: Reactor {
    
    typealias Action = NoAction
    typealias Mutation = NoMutation
    
    struct State {
        var id: String?
        var name: String?
        var totlaCount: Int
        var isSelected: Bool
    }
    
    let initialState: State

    // MARK: Initializing
    
    init(group: Group?, isSelected: Bool) {
        initialState = State(
            id: group?.id,
            name: group?.name,
            totlaCount: group?.count ?? 0,
            isSelected: isSelected
        )
    }
}
