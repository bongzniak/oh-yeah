//
//  VocabularyCellReactor.swift
//  VocabularyTests
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

import Core

class VocabularyCellReactor: Reactor {
    
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
        let vocabulary: Vocabulary
    }
    
    let initialState: State

    // MARK: Initializing
    
    init(vocabulary: Vocabulary) {
        initialState = State(vocabulary: vocabulary)
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        }
    }
    
    // MARK: Reduce
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        }
        return state
    }
}
