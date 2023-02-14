//
//  ModelType.swift
//  Core
//
//  Created by bongzniak on 2023/02/14.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

import Then

public protocol ModelType: Codable, Then {
    associatedtype Event
}
