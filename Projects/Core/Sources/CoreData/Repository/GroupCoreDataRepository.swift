//
//  GroupCoreDataRepository.swift
//  Core
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import CoreData

public protocol GroupRepositoryType {
    func fetchGroups(with predicate: GroupFetchPredicate?) -> GroupResponse
    func createGroup(_ group: GroupRequest) -> Group
}

public class GroupCoreDataRepository: GroupRepositoryType {
    
    private let coreDataManager: CoreDataManager
    
    public init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    public func fetchGroups(
        with predicate: GroupFetchPredicate? = nil
    ) -> GroupResponse {
        let request: NSFetchRequest<GroupEntity> = GroupEntity.fetchRequest()
        var fetchedResult: [GroupEntity] = []
        
        var predicates: [NSPredicate] = []
        if let predicate = predicate {
            predicates.append(NSPredicate(format: "name CONTAINS %@", predicate.name))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            fetchedResult = try coreDataManager.persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching vocabularies \(error)")
        }
        
        let items: [Group] = fetchedResult.map {
            Group(
                id: $0.id,
                name: $0.name,
                count: $0.vocabularies?.count ?? 0
            )
        }
        let count = items.count
        let hasNext = false
        
        return GroupResponse(items: items, count: count, hasNext: hasNext)
    }
    
    public func createGroup(_ group: GroupRequest) -> Group {
        let groupEntity = GroupEntity(
            context: coreDataManager.persistentContainer.viewContext
        )
        
        groupEntity.name = group.name
        
        coreDataManager.saveContext()
        
        return Group(
            id: groupEntity.id,
            name: groupEntity.name,
            count: groupEntity.vocabularies?.count ?? 0
        )
    }
}
