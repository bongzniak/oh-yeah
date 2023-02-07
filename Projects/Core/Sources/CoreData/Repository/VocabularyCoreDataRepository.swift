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
    func fetchVocabularies() -> VocabularyResponse
}

public class VocabularyCoreDataRepository: VocabularyRepositoryType {
    
    private let coreDataManager: CoreDataManager
    
    public init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    public func fetchVocabularies() -> VocabularyResponse {
        let request: NSFetchRequest<VocabulayEntity> = VocabulayEntity.fetchRequest()
        var fetchedResult: [VocabulayEntity] = []
        
        do {
            fetchedResult = try coreDataManager.persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching vocabularies \(error)")
        }
        
        let items: [Vocabulary] = fetchedResult.map {
            Vocabulary(spelling: $0.title, description: $0.subtitle)
        }
        let count = fetchVocabulayCount()
        let hasNext = count >= items.count
        
        return VocabularyResponse(items: items, count: count, hasNext: hasNext)
    }
    
    private func fetchVocabulayCount() -> Int {
        let request: NSFetchRequest<VocabulayEntity> = VocabulayEntity.fetchRequest()
        do {
            let count = try coreDataManager.persistentContainer.viewContext.count(for: request)
            return count
        } catch {
            print(error)
            return 0
        }
    }
    
//    public func saveVocabulary(vocabulary: Vocabulary) -> VocabulayEntity {
//        let test = VocabulayEntity(context: coreDataManager.persistentContainer.viewContext)
//        test.title = vocabulary.spelling
//        test.subtitle = vocabulary.description
//        
//        coreDataManager.saveContext()
//        
//        return test
//    }
}
