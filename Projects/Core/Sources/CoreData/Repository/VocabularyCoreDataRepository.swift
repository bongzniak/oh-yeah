//
//  VocabularyRepository.swift
//  Core
//
//  Created by bongzniak on 2023/02/05.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import CoreData

public protocol VocabularyRepositoryType {
    func fetchVocabularies(with predicate: VocabularyFetchPredicate?) -> VocabularyResponse
    func createVocabulary(_ request: VocabularyRequest) -> Vocabulary
    func updateVocabulary(_ request: VocabularyRequest) -> Vocabulary
}

public class VocabularyCoreDataRepository: VocabularyRepositoryType {
    
    private let coreDataManager: CoreDataManager
    
    public init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    public func fetchVocabularies(
        with predicate: VocabularyFetchPredicate? = nil
    ) -> VocabularyResponse {
        let request: NSFetchRequest<VocabulayEntity> = VocabulayEntity.fetchRequest()
        var fetchedResult: [VocabulayEntity] = []
        
        var predicates: [NSPredicate] = []
        if let predicate = predicate {
            predicates.append(NSPredicate(format: "group.id = %@", predicate.groupID))
//            if let section = predicate.section {
//                predicates.append(NSPredicate(format: "section = %d", section))
//            }
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            fetchedResult = try coreDataManager.persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching vocabularies \(error)")
        }
        
        let items: [Vocabulary] = fetchedResult.map {
            Vocabulary(
                id: $0.id,
                spelling: $0.spelling,
                description: $0.desc,
                sentence: $0.sentence,
                group: Group(groupEntity: $0.group)
            )
        }
        let count = items.count
        let hasNext = false
        
        return VocabularyResponse(items: items, count: count, hasNext: hasNext)
    }
    
    public func createVocabulary(_ request: VocabularyRequest) -> Vocabulary {
        let vocabularyEntity = VocabulayEntity(
            context: coreDataManager.persistentContainer.viewContext
        )
        
        vocabularyEntity.spelling = request.spelling
        vocabularyEntity.desc = request.description
        vocabularyEntity.sentence = request.sentence
        
        let groupEntity: GroupEntity? = fetchGroup(request.groupID)
        if let groupEntity {
            groupEntity.addToVocabularies(vocabularyEntity)
        }
        
        coreDataManager.saveContext()
        
        return Vocabulary(
            id: vocabularyEntity.id,
            spelling: vocabularyEntity.spelling,
            description: vocabularyEntity.desc,
            sentence: vocabularyEntity.sentence,
            group: Group(groupEntity: groupEntity)
        )
    }
    
    public func updateVocabulary(_ request: VocabularyRequest) -> Vocabulary {
        let vocabularyEntity = fetchVocabulary(request.vocabularyID ?? "")
        vocabularyEntity.spelling = request.spelling
        vocabularyEntity.desc = request.description
        vocabularyEntity.sentence = request.sentence
        
        if let groupID = vocabularyEntity.group?.id,
            request.groupID != groupID {
            let groupEntity = fetchGroup(request.groupID)
            vocabularyEntity.group = groupEntity
        }
        
        coreDataManager.saveContext()
        
        return Vocabulary(
            id: vocabularyEntity.id,
            spelling: vocabularyEntity.spelling,
            description: vocabularyEntity.desc,
            sentence: vocabularyEntity.sentence,
            group: Group(groupEntity: vocabularyEntity.group)
        )
    }
    
    private func fetchVocabulary(_ id: String) -> VocabulayEntity {
        let request: NSFetchRequest<VocabulayEntity> = VocabulayEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        request.fetchLimit = 1
        
        var fetchedResult: [VocabulayEntity] = []
        
        do {
            fetchedResult = try coreDataManager.persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching vocabularies \(error)")
        }
        
        return fetchedResult.first ?? VocabulayEntity()
    }
    
    private func fetchGroup(_ id: String) -> GroupEntity? {
        let request: NSFetchRequest<GroupEntity> = GroupEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        request.fetchLimit = 1
        
        var fetchedResult: [GroupEntity] = []
        
        do {
            fetchedResult = try coreDataManager.persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching vocabularies \(error)")
        }
        
        return fetchedResult.first
    }
}
