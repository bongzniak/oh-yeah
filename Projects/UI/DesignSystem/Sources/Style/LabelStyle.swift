//
//  LabelStyle.swift
//  DesignSystem
//
//  Created by bongzniak on 2023/02/10.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import UIKit

public struct LabelStyle {
    var font: UIFont
    var textColor: UIColor
    var numberOfLine: Int
    
    public init(font: UIFont, textColor: UIColor, numberOfLine: Int = 0) {
        self.font = font
        self.textColor = textColor
        self.numberOfLine = numberOfLine
    }
}
