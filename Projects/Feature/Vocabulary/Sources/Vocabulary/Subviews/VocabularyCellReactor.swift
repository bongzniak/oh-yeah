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
    
    typealias Action = NoAction
    typealias Mutation = NoMutation
    
    struct State {
        let vocabulary: Vocabulary
        var isShowDescription: Bool {
            !vocabulary.description.isEmpty && vocabulary.isExpand
        }
        var isShowSentence: Bool {
            !vocabulary.sentence.isEmpty && vocabulary.isExpand
        }
    }
    
    let initialState: State

    // MARK: Initializing
    
    init(vocabulary: Vocabulary) {
        initialState = State(vocabulary: vocabulary)
    }
}
