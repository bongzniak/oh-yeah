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
        case updateVocabularies(VocabularyResponse)
        case updateSections([VocabularySection])
    }
    
    struct State {
        @Pulse var sections: [VocabularySection] = []
        @Pulse var isRefreshing: Bool = false
    }
    
    let initialState: State
    
    let vocabularyService: VocabularyServiceType
    
    private var vocabularies: [Vocabulary] = []
    
    // MARK: Initializing
    
    init(vocabularyService: VocabularyServiceType) {
        self.vocabularyService = vocabularyService
        
        initialState = State()
    }
    
    // MARK: Mutate
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .fetch:
                return fetchVocabularies()
            
            case .refresh:
                return .concat([
                    .just(.setRefreshing(true)),
                    fetchVocabularies(),
                    .just(.setRefreshing(false))
                ])
                
            case .updateVocabulary(let vocabulaty):
                if let index = vocabularies.firstIndex(where: { $0 == vocabulaty }) {
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
                
            case .updateVocabularies(let response):
                vocabularies = response.items
                state.sections = [generateVocabularySection()]
        }
        
        return state
    }
}

extension VocabularyViewReactor {
    
    private func fetchVocabularies() -> Observable<Mutation> {
        vocabularyService.fetchVocabularies()
            .map { response -> Mutation in
                return .updateVocabularies(response)
            }
    }
    
    private func generateVocabularySection() -> VocabularySection {
        .section(
            vocabularies.map { vocabulary -> VocabularySection.Item in
                    .vocabulary(vocabulary)
            }
        )
    }
}
