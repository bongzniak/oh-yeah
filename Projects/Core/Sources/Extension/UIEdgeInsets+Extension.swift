//
//  UIEdgeInsets+Extension.swift
//  Core
//
//  Created by bongzniak on 2023/02/03.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    
    public init(left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: 0, left: left, bottom: bottom, right: right)
    }
    
    public init(top: CGFloat, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: top, left: 0, bottom: bottom, right: right)
    }
    
    public init(top: CGFloat, left: CGFloat, right: CGFloat = 0) {
        self.init(top: top, left: left, bottom: 0, right: right)
    }
    
    public init(top: CGFloat, left: CGFloat, bottom: CGFloat) {
        self.init(top: top, left: left, bottom: bottom, right: 0)
    }
    
    public init(_ all: CGFloat) {
        self.init(horizontal: all, vertical: all)
    }
    
    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    public init(horizontal: CGFloat, top: CGFloat = 0, bottom: CGFloat = 0) {
        self.init(top: top, left: horizontal, bottom: bottom, right: horizontal)
    }
    
    public init(vertical: CGFloat, left: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: vertical, left: left, bottom: vertical, right: right)
    }
    
    public var horizontal: CGFloat {
        self.left + self.right
    }
    
    public var vertical: CGFloat {
        self.top + self.bottom
    }
}
