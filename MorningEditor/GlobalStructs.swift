//
//  GlobalStructs.swift
//  MorningEditor
//
//  Created by alien on 2019/4/17.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation

//for labels(textableLabelView) on the image, and for colorModeButtons(button which determine the label should edit text color, stroke color or shadow color)
enum ColorState: Int {
    case foregroundMode
    case strokeMode
    case shadowMode
}

//to notify the controller which gesture event has been triggered, this struct has been used in GestureRespondDelegate protocol
enum GestureEvent {
    case tap
    case pan
    case pinch
}
