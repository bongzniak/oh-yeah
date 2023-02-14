//
//  VocabulariesViewReactor.swift
//  Vocabulary
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

import Core

final class VocabulariesViewReactor: BaseReactor, Reactor {
    
    enum Action {
        case fetch(Group?)
        case refresh
        case shuffle
        case update(Vocabulary)
        case groupSelectButtonDidTap
        case plusActionButtonDidTap
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case updateVocabularies(VocabularyResponse)
        case updateSections([VocabularySection])
        case updateGroup(Group?)
        case saveVocabulary(Vocabulary)
    }
    
    struct State {
        @Pulse var sections: [VocabularySection] = []
        @Pulse var isRefreshing: Bool = false
        @Pulse var group: Group?
    }
    
    let initialState: State
    
    private let coordinator: VocabulariesCoordinator
    private let vocabularyService: VocabularyServiceType
    
    private var vocabularies: [Vocabulary] = []
    
    // MARK: Initializing
    
    init(
        coordinator: VocabulariesCoordinator,
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
            case .fetch(let group):
                return .concat([
                    fetchVocabularies(with: group),
                    .just(.updateGroup(group))
                ])
            
            case .refresh:
                return .concat([
                    .just(.setRefreshing(true)),
                    fetchVocabularies(with: currentState.group),
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
                
            case .groupSelectButtonDidTap:
                coordinator.pushToGroup()
                return .empty()
                
            case .plusActionButtonDidTap:
                coordinator.pushToSaveVocabulary()
                return .empty()
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let events = Vocabulary.event.flatMap { [weak self] event in
            self?.mutation(from: event) ?? .empty()
        }
        return Observable.of(mutation, events).merge()
    }
    
    func mutation(from event: Vocabulary.Event) -> Observable<Mutation> {
        switch event {
            case .save(let vocabulary):
                guard currentState.group == nil
                        || vocabulary.group == currentState.group else { return .empty() }
                
                return .just(.saveVocabulary(vocabulary))
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
                
            case .updateGroup(let group):
                state.group = group
                
            case .saveVocabulary(let vocabulary):
                if let index = vocabularies.firstIndex(where: { $0 == vocabulary }) {
                    self.vocabularies[index] = vocabulary
                } else {
                    self.vocabularies.insert(vocabulary, at: 0)
                }
                state.sections = [generateVocabularySection()]
        }
        
        return state
    }
}

extension VocabulariesViewReactor {
    private func fetchVocabularies(with group: Group? = nil) -> Observable<Mutation> {
        vocabularyService.fetchVocabularies(
            with: VocabularyFetchPredicate(group: group)
        )
            .map {
                .updateVocabularies($0)
            }
    }
    
    private func generateVocabularySection() -> VocabularySection {
        var items = vocabularies.map { vocabulary -> VocabularySection.Item in
                .vocabulary(vocabulary)
        }
        
        if items.isEmpty {
            items = [.empty]
        }
        
        return .section(items)
    }
}

extension VocabulariesViewReactor: VocabulariesCoordinatorDelegate {
    func selectedGroups(_ groups: [Group]) {
        guard currentState.group != groups.first else { return }
        
        action.onNext(.fetch(groups.first))
    }
}
