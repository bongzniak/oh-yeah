//
//  SelectType.swift
//  Core
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

public enum SelectMode: String, Codable {
    case single
    case multiple
    case none = "NONE"
    
    public init(from decoder: Decoder) throws {
        self = try SelectMode(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .none
    }
}
