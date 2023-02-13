//
//  SaveVocabularyViewReactor.swift
//  VocabularyDemoApp
//
//  Created by bongzniak on 2023/02/06.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

import Core
import Foundation

final class SaveVocabularyViewReactor: BaseReactor, Reactor {
  
    enum Action {
        case save
        case onChangedGroup(Group?)
        case onChangedSpelling(String)
        case onChangedDescription(String)
        case onChangedSentence(String)
        
        case groupSelectButtonDidTap
        case closeButtonDidTap
    }

    enum Mutation {
        case saveComplete
        case updateGroup(Group?)
        case updateSpelling(String)
        case updateDescription(String)
        case updateSentence(String)
    }

    struct State {
        @Pulse var group: Group?
        @Pulse var vocabularyID: String?
        @Pulse var spelling: String
        @Pulse var description: String
        @Pulse var sentence: String
    }

    let initialState: State
    
    private let coordinator: SaveVocabularyCoordinator
    private let vocabularyService: VocabularyServiceType
    
    // MARK: Initializing
    
    init(
        coordinator: SaveVocabularyCoordinator,
        vocabulary: Vocabulary?,
        vocabularyService: VocabularyServiceType
    ) {
        self.coordinator = coordinator
        self.vocabularyService = vocabularyService
        
        initialState = State(
            group: vocabulary?.group,
            vocabularyID: vocabulary?.id,
            spelling: vocabulary?.spelling ?? "",
            description: vocabulary?.description ?? "",
            sentence: vocabulary?.sentence ?? ""
        )
        
        super.init()
        
        self.coordinator.delegate = self
    }
    
    // MARK: Mutate

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .save:
                return .concat([
                    save(),
                    .just(.updateSpelling("")),
                    .just(.updateDescription("")),
                    .just(.updateSentence("")),
                ])
                
            case .onChangedGroup(let group):
                return .just(.updateGroup(group))
                
            case .onChangedSpelling(let spelling):
                return .just(.updateSpelling(spelling))
                
            case .onChangedDescription(let description):
                return .just(.updateDescription(description))
                
            case .onChangedSentence(let sentence):
                return .just(.updateSentence(sentence))
                
            case .groupSelectButtonDidTap:
                coordinator.pushToGroup(selectMode: .single, selectIDs: [])
                return .empty()
                
            case .closeButtonDidTap:
                coordinator.close()
                return .empty()
        }
    }

    // MARK: Reduce

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
            case .saveComplete:
                state.vocabularyID = nil
                state.spelling = ""
                state.description = ""
                state.sentence = ""
                
            case .updateGroup(let group):
                state.group = group
            
            case .updateSpelling(let spelling):
                state.spelling = spelling
                
            case .updateDescription(let description):
                state.description = description
                
            case .updateSentence(let sentence):
                state.sentence = sentence
        }

        return state
    }
}

extension SaveVocabularyViewReactor {
    private func save() -> Observable<Mutation> {
        guard let groupID = currentState.group?.id else { return .empty() }
        
        let vocabularyEntity = VocabularyRequest(
            groupID: groupID,
            vocabularyID: currentState.vocabularyID,
            spelling: currentState.spelling,
            description: currentState.description,
            sentence: currentState.sentence
        )
        
        return vocabularyService.createVocabulary(vocabularyEntity).map { _ in
            .saveComplete
        }
    }
}

extension SaveVocabularyViewReactor: SaveVocabularyCoordinatorDelegate {
    func selectedGroups(_ groups: [Group]) {
        action.onNext(.onChangedGroup(groups.first))
    }
}
