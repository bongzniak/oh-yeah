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

final class VocabularyViewReactor: BaseReactor, Reactor {
    
    enum Action {
        case fetch
        case refresh
        case shuffle
        case update(Vocabulary)
        case plusActionButtonDidTap
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case updateVocabularies(VocabularyResponse)
        case updateSections([VocabularySection])
    }
    
    struct State {
        @Pulse var sections: [VocabularySection] = []
        @Pulse var isRefreshing: Bool = false
        @Pulse var group: Group?
    }
    
    let initialState: State
    
    let coordinator: VocabularyCoordinator
    let vocabularyService: VocabularyServiceType
    
    private var vocabularies: [Vocabulary] = []
    
    // MARK: Initializing
    
    init(
        coordinator: VocabularyCoordinator,
        vocabularyService: VocabularyServiceType
    ) {
        self.coordinator = coordinator
        self.vocabularyService = vocabularyService
        
        initialState = State()
        
        super.init()
        
        coordinator.delegate = self
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
                
            case .shuffle:
                self.vocabularies = self.vocabularies.shuffled()
                return .just(.updateSections([generateVocabularySection()]))
                
            case .update(let vocabulaty):
                if let index = vocabularies.firstIndex(where: { $0 == vocabulaty }) {
                    vocabularies[index] = vocabulaty
                }
                
                return .just(.updateSections([generateVocabularySection()]))
                
            case .plusActionButtonDidTap:
                coordinator.pushToSaveVocabulary()
                return .empty()
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
        let predicate: VocabularyFetchPredicate? = nil
        return vocabularyService.fetchVocabularies(with: predicate)
            .map { response -> Mutation in
                return .updateVocabularies(response)
            }
    }
    
    private func generateVocabularySection() -> VocabularySection {
        var items = vocabularies.map { vocabulary -> VocabularySection.Item in
                .vocabulary(vocabulary)
        }
        
        if items.isEmpty {
            items.append(.empty)
        }
        
        return .section(items)
    }
}

extension VocabularyViewReactor: VocabularyCoordinatorDelegate {
    func selectedGroup(_ group: Group?) {
        logger.debug("group >> ", group)
    }
}
