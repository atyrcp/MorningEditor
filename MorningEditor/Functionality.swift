//
//  Functionality.swift
//  MorningEditor
//
//  Created by alien on 2019/4/19.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func cutCorner(to radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.mask = maskLayer
    }
}

extension UIPinchGestureRecognizer {
    func scale(view: UIView) -> (x: CGFloat, y: CGFloat)? {
        if numberOfTouches > 1 {
            let touch1 = self.location(ofTouch: 0, in: view)
            let touch2 = self.location(ofTouch: 1, in: view)
            let deltaX = abs(touch1.x - touch2.x)
            let deltaY = abs(touch1.y - touch2.y)
            let sum = deltaX + deltaY
            if sum > 0 {
                let scale = self.scale
                return (1.0 + (scale - 1.0) * (deltaX / sum), 1.0 + (scale - 1.0) * (deltaY / sum))
            }
        }
        return nil
    }
}

extension UIImageView {
    func getImageRect() -> CGRect {
        let imageViewSize = self.frame.size
        guard let imageSize = image?.size else {return CGRect.zero}
        
        let widthRatio = imageViewSize.width / imageSize.width
        let heightRatio = imageViewSize.height / imageSize.height
        let ratio = fmin(widthRatio, heightRatio)
        
        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * ratio, height: imageSize.height * ratio)
        
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
        
        imageRect.origin.x += self.frame.origin.x
        imageRect.origin.y += self.frame.origin.y
        
        return imageRect
    }
}

extension Array {
    func appendImages(byImageNames strings: [String]) -> [UIImage] {
        var images = [UIImage]()
        for string in strings {
            if let image = UIImage(named: string) {
                images.append(image)
            }
        }
        return images
    }
}
