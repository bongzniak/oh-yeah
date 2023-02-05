//
//  VocabularyRepository.swift
//  Core
//
//  Created by bongzniak on 2023/02/05.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import CoreData

public protocol VocabularyStore {
    func fetchVocabularies() -> [Vocabulary]
}

public class VocabularyRepository: VocabularyStore {
    
    private let coreDataManager: CoreDataManager
    
    public init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    public func fetchVocabularies() -> [Vocabulary] {
        let request: NSFetchRequest<VocabulayEntity> = VocabulayEntity.fetchRequest()
        var fetchedResult: [VocabulayEntity] = []
        
        do {
            fetchedResult = try coreDataManager.persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching vocabularies \(error)")
        }
        
        return fetchedResult.map {
            Vocabulary(spelling: $0.title, description: $0.subtitle)
        }
    }
    
    public func saveVocabulary(vocabulary: Vocabulary) -> VocabulayEntity {
        let test = VocabulayEntity(context: coreDataManager.persistentContainer.viewContext)
        test.title = vocabulary.spelling
        test.subtitle = vocabulary.description
        
        coreDataManager.saveContext()
        
        return test
    }
}
