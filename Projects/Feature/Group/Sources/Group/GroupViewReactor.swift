//
//  GroupViewReactor.swift
//  Group
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

import Core

final class GroupViewReactor: BaseReactor, Reactor {
    
    enum Action {
        case fetch(keyword: String)
        case refresh
        case createGroup(name: String)
        case clickGroup(id: String)
        
        case backBarButtonDidTap
        case plusActionButton(
            title: String,
            message: String,
            okTitle: String,
            cancelTitle: String
        )
    }
    
    enum Mutation {
        case updateGroups(GroupResponse)
        case appendGroup(Group)
        case setRefreshing(Bool)
        case updateSections([GroupSection])
    }
    
    struct State {
        @Pulse var sections: [GroupSection] = []
        @Pulse var isRefreshing: Bool = false
    }
    
    let coordinator: GroupCoordinator
    let groupService: GroupServiceType
    
    let initialState: State
    
    private var groups: [Group] = []
    
    private let selectMode: SelectMode
    var selectedIDs = Set<String>()
    
    // MARK: Initializing
    
    init(
        coordinator: GroupCoordinator,
        groupService: GroupServiceType,
        selectMode: SelectMode,
        selectedIDs: Set<String>
    ) {
        self.coordinator = coordinator
        self.groupService = groupService
        self.selectMode = selectMode
        self.selectedIDs = selectedIDs
        
        initialState = State()
        
        super.init()
        
        coordinator.delegate = self
    }
    
    deinit {
        
    }
    
    // MARK: Mutate
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .fetch(let keyword):
                selectedIDs = []
                return fetchGroups(keyword: keyword)
                
            case .refresh:
                return .concat([
                    .just(.setRefreshing(true)),
                    .just(.setRefreshing(false))
                ])
                
            case .createGroup(let name):
                return createGroup(name: name)
                
            case .clickGroup(let id):
                toggleGroup(id: id)
                return .just(.updateSections([generateSections()]))
                
            case .backBarButtonDidTap:
                coordinator.close()
                return .empty()
                
            case .plusActionButton(
                let title,
                let message,
                let okTitle,
                let cancelTitle
            ):
                coordinator.presentCreateGroup(
                    title: title,
                    message: message,
                    okTitle: okTitle,
                    cancelTitle: cancelTitle
                )
                return .empty()
        }
    }
    
    // MARK: Reduce
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
            case .updateGroups(let groups):
                self.groups = groups.items
                state.sections = [generateSections()]
                
            case .setRefreshing(let isRefreshing):
                state.isRefreshing = isRefreshing
                
            case .appendGroup(let group):
                self.groups.append(group)
                state.sections = [generateSections()]
                
            case .updateSections(let sections):
                state.sections = sections
        }
        
        return state
    }
}

extension GroupViewReactor {
    private func fetchGroups(keyword: String) -> Observable<Mutation> {
        var predicate: GroupFetchPredicate?
        
        if !keyword.isEmpty {
            predicate = GroupFetchPredicate(name: keyword)
        }
        
        return groupService.fetchGroups(with: predicate)
            .map { .updateGroups($0)}
    }
    
    
    private func createGroup(name: String) -> Observable<Mutation> {
        groupService.createGroup(GroupRequest(name: name))
            .map { .appendGroup($0) }
    }
    
    private func toggleGroup(id: String) {
        let isSelected = selectedIDs.contains(id)
        switch selectMode {
            case .single:
                selectedIDs.removeAll()
                if !isSelected {
                    selectedIDs.insert(id)
                }
                
            case .multiple:
                selectedIDs.remove(id)
                if !isSelected {
                    selectedIDs.insert(id)
                }
                
            case .none:
                selectedIDs = []
        }
    }
    
    private func generateSections() -> GroupSection {
        let sectionItems: [GroupSection.Item] = groups.map {
            .group($0, isSelected: selectedIDs.contains($0.id))
        }
        return .section(sectionItems)
    }
}


// MARK: GroupCoordinatorDelegate

extension GroupViewReactor: GroupCoordinatorDelegate {
    func createGroup(name: String) {
        action.onNext(.createGroup(name: name))
    }
}
