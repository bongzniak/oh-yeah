//
//  String+Extension.swift
//  Core
//
//  Created by bongzniak on 2023/02/02.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import UIKit

extension String {
    public func textSize(
        font: UIFont,
        width: CGFloat = .greatestFiniteMagnitude,
        height: CGFloat = .greatestFiniteMagnitude,
        numberOnLineLines: Int = 0
    ) -> CGSize {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        label.numberOfLines = numberOnLineLines
        label.font = font
        label.text = self
        label.sizeToFit()
        
        return label.frame.size
    }
}
