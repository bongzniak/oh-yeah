//
//  GroupService.swift
//  Core
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

import Moya
import RxSwift

public protocol GroupServiceType {
    func fetchGroups(with predicate: GroupFetchPredicate?) -> Observable<GroupResponse>
    func createGroup(_ group: GroupRequest) -> Observable<Group>
}

public final class GroupCoreDataService: NSObject, GroupServiceType {
    
    private let repository: GroupRepositoryType
    
    public init(repository: GroupRepositoryType) {
        self.repository = repository
    }
    
    public func fetchGroups(with predicate: GroupFetchPredicate?) -> Observable<GroupResponse> {
        return Observable<GroupResponse>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            let response = self.repository.fetchGroups(with: predicate)
            observer.onNext(response)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    public func createGroup(_ group: GroupRequest) -> Observable<Group> {
        return Observable<Group>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            let response = self.repository.createGroup(group)
            observer.onNext(response)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
