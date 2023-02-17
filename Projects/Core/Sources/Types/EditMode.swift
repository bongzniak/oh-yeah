//
//  EditMode.swift
//  Core
//
//  Created by bongzniak on 2023/02/17.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation


public enum EditMode<Element> {
    case create(Group?)
    case update(Element)
}
