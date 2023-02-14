//
//  ModelStream.swift
//  Core
//
//  Created by bongzniak on 2023/02/14.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation

import RxSwift

private var streams: [String: Any] = [:]

extension ModelType {
    public static var event: PublishSubject<Event> {
        let key = String(describing: self)
        if let stream = streams[key] as? PublishSubject<Event> {
            return stream
        }
        let stream = PublishSubject<Event>()
        streams[key] = stream
        return stream
    }
}
