//
//  VocabularyService.swift
//  Core
//
//  Created by bongzniak on 2023/02/03.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

import Moya
import RxSwift 

public protocol VocabularyServiceType {
    func fetchVocabularies() -> Observable<[Vocabulary]>
}

public final class VocabularyCoreDataService: NSObject, VocabularyServiceType {
    
    public let coreDataManager: CoreDataManager
    
    public init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    public func fetchVocabularies() -> Observable<[Vocabulary]> {
        return Observable<[Vocabulary]>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            let vocabularies = self.coreDataManager.fetchVocabularies()
            observer.onNext(vocabularies)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}