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
        case saveComplete(Vocabulary)
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
    
    private let editMode: EditMode<Vocabulary>
    
    // MARK: Initializing
    
    init(
        coordinator: SaveVocabularyCoordinator,
        vocabularyService: VocabularyServiceType,
        editMode: EditMode<Vocabulary>
    ) {
        self.coordinator = coordinator
        self.vocabularyService = vocabularyService
        self.editMode = editMode
        
        var vocabulary: Vocabulary?
        var selectedGroup: Group?
        
        switch editMode {
            case .create(let group):
                selectedGroup = group
                
            case .update(let item):
                selectedGroup = item.group
                vocabulary = item
        }
        
        initialState = State(
            group: selectedGroup,
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
                coordinator.pushToGroup(with: currentState.group)
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
            case .saveComplete(let vocabulary):
                Vocabulary.event.onNext(.save(vocabulary))
                
                switch editMode {
                    case .create:
                        state.vocabularyID = nil
                        state.spelling = ""
                        state.description = ""
                        state.sentence = ""
                        
                    case .update:
                        coordinator.close()
                }
                
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
        
        let request = VocabularyRequest(
            groupID: groupID,
            vocabularyID: currentState.vocabularyID,
            spelling: currentState.spelling,
            description: currentState.description,
            sentence: currentState.sentence
        )
        
        return saveVocabulary(request: request)
            .map { .saveComplete($0) }
    }
    
    private func saveVocabulary(request: VocabularyRequest) -> Observable<Vocabulary> {
        switch editMode {
            case .create:
                return vocabularyService.createVocabulary(request)
                
            case .update:
                return vocabularyService.updateVocabulary(request)
        }
    }
}

extension SaveVocabularyViewReactor: SaveVocabularyCoordinatorDelegate {
    func selectedGroups(_ groups: [Group]) {
        action.onNext(.onChangedGroup(groups.first))
    }
}
