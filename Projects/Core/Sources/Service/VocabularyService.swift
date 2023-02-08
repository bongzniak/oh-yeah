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
    func fetchVocabularies(
        with predicate: VocabularyFetchPredicate?
    ) -> Observable<VocabularyResponse>
    func createVocabulary(_ request: VocabularyRequest) -> Observable<Vocabulary>
}

public final class VocabularyCoreDataService: NSObject, VocabularyServiceType {
    
    private let repository: VocabularyRepositoryType
    
    public init(repository: VocabularyRepositoryType) {
        self.repository = repository
    }
    
    public func fetchVocabularies(
        with predicate: VocabularyFetchPredicate? = nil
    ) -> Observable<VocabularyResponse> {
        return Observable<VocabularyResponse>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            let response = self.repository.fetchVocabularies(with: predicate)
            observer.onNext(response)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    public func createVocabulary(_ request: VocabularyRequest) -> Observable<Vocabulary> {
        return Observable<Vocabulary>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            let response = self.repository.createVocabulary(request)
            observer.onNext(response)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
