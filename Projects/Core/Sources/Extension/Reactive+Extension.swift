//
//  Reactive+Extension.swift
//  Core
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

// MARK: - UIButton
extension Reactive where Base: UIButton {
    public var throttleTap: Observable<Void> {
        return self.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
    }
}

// MARK: - UIBarButtonItem
extension Reactive where Base: UIBarButtonItem {
    public var throttleTap: Observable<Void> {
        return self.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
    }
}
