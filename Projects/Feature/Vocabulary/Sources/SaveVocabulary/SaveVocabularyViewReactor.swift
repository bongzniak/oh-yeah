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
        case onChangedSpelling(String)
        case onChangedDescription(String)
        case onChangedSentence(String)
    }

    enum Mutation {
        case saveComplete
        case updateSpelling(String)
        case updateDescription(String)
        case updateSentence(String)
    }

    struct State {
        @Pulse var groupID: String?
        @Pulse var vocabularyID: String?
        @Pulse var spelling: String
        @Pulse var description: String
        @Pulse var sentence: String
    }

    let initialState: State
    
    let coordinator: SaveVocabularyCoordinator
    let vocabularyService: VocabularyServiceType

    // MARK: Initializing
    
    init(
        coordinator: SaveVocabularyCoordinator,
        groupID: String?,
        vocabularyID: String?,
        vocabularyService: VocabularyServiceType
    ) {
        self.coordinator = coordinator
        self.vocabularyService = vocabularyService
        
        initialState = State(
            groupID: groupID,
            vocabularyID: vocabularyID,
            spelling: "",
            description: "",
            sentence: ""
        )
        
        super.init()
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
                
            case .onChangedSpelling(let spelling):
                return .just(.updateSpelling(spelling))
                
            case .onChangedDescription(let description):
                return .just(.updateDescription(description))
                
            case .onChangedSentence(let sentence):
                return .just(.updateSentence(sentence))
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
        vocabularyService.createVocabulary(
            VocabularyRequest(
                groupID: "group",
                vocabularyID: currentState.vocabularyID ?? UUID().uuidString,
                spelling: currentState.spelling,
                description: currentState.description,
                sentence: currentState.sentence
            )
        )
        .map { _ in
                .saveComplete
        }
    }
}
