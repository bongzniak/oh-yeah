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

final class SaveVocabularyViewReactor: Reactor {
  
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
        var groupID: String?
        var vocabularyID: String?
        var spelling: String
        var description: String
        var sentence: String
    }

    let initialState: State
    
    let vocabularyService: VocabularyServiceType

    // MARK: Initializing
    
    init(
        groupID: String?,
        vocabularyID: String?,
        vocabularyService: VocabularyServiceType
    ) {
        self.vocabularyService = vocabularyService
        
        initialState = State(
            groupID: groupID,
            vocabularyID: vocabularyID,
            spelling: "",
            description: "",
            sentence: ""
        )
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
