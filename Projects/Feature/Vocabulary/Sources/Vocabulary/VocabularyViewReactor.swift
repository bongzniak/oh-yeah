//
//  VocabularyViewReactor.swift
//  Vocabulary
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

import Core

final class VocabularyViewReactor: Reactor {
    
    enum Action {
        case fetch
        case refresh
        case updateVocabulary(Vocabulary)
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case updateSections([VocabularySection])
    }
    
    struct State {
        var sections: [VocabularySection] = []
        @Pulse var isRefreshing: Bool = false
    }
    
    let initialState: State
    
    private var vocabularies: [Vocabulary] = [
        Vocabulary.random(),
        Vocabulary.random(),
        Vocabulary.random(),
        Vocabulary.random(),
        Vocabulary.random(),
    ]
    
    // MARK: Initializing
    
    init() {
        initialState = State()
    }
    
    // MARK: Mutate
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .fetch:
                return .just(.updateSections([generateVocabularySection()]))
            
            case .refresh:
                vocabularies = [
                    Vocabulary.random(),
                    Vocabulary.random(),
                    Vocabulary.random(),
                    Vocabulary.random(),
                    Vocabulary.random(),
                    Vocabulary.random(),
                    Vocabulary.random(),
                    Vocabulary.random(),
                    Vocabulary.random(),
                    Vocabulary.random(),
                ]
                
                return .concat([
                    .just(.setRefreshing(true)),
                    .just(.updateSections([generateVocabularySection()])),
                    .just(.setRefreshing(false))
                ])
                
            case .updateVocabulary(var vocabulaty):
                vocabulaty.isExpand.toggle()
                if let index = vocabularies.firstIndex(
                    where: {$0.spelling == vocabulaty.spelling }
                ) {
                    vocabularies[index] = vocabulaty
                }
                
                return .just(.updateSections([generateVocabularySection()]))
        }
    }
    
    // MARK: Reduce
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
            case .setRefreshing(let isRefreshing):
                state.isRefreshing = isRefreshing
                
            case .updateSections(let sections):
                state.sections = sections
        }
        
        return state
    }
}

extension VocabularyViewReactor {
    private func generateVocabularySection() -> VocabularySection {
        .section(
            vocabularies.map { vocabulary -> VocabularySection.Item in
                    .vocabulary(vocabulary)
            }
        )
    }
}
