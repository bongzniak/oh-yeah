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
    func fetchVocabularies() -> Observable<VocabularyResponse>
}

public final class VocabularyCoreDataService: NSObject, VocabularyServiceType {
    
    private let vocalbularyStore: VocabularyRepositoryType
    
    public init(vocalbularyStore: VocabularyRepositoryType) {
        self.vocalbularyStore = vocalbularyStore
    }
    
    public func fetchVocabularies() -> Observable<VocabularyResponse> {
        return Observable<VocabularyResponse>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            let response = self.vocalbularyStore.fetchVocabularies()
            observer.onNext(response)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
