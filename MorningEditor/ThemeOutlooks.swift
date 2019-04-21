//
//  ThemeOutlooks.swift
//  MorningEditor
//
//  Created by alien on 2019/3/31.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func makeCustomColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static let customGainsBoro = UIColor.makeCustomColor(220, 220, 221)
    static let customLavenderGray = UIColor.makeCustomColor(197, 195, 198)
    static let customOuterSpace = UIColor.makeCustomColor(70, 73, 76)
    static let customDeepSpaceSparkle = UIColor.makeCustomColor(76, 92, 104)
    static let customCgBlue = UIColor.makeCustomColor(25, 133, 161)
}

