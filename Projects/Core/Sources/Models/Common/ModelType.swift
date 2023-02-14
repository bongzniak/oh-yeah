//
//  ModelType.swift
//  Core
//
//  Created by bongzniak on 2023/02/14.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

import Then

protocol ModelType: Codable, Then {
    associatedtype Event
    
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension ModelType {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .iso8601
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = self.dateDecodingStrategy
        return decoder
    }
}
