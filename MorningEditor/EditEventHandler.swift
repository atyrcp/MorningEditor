//
//  GestureEventHandler.swift
//  MorningEditor
//
//  Created by alien on 2019/4/12.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation
import UIKit

class EditEventHandler {
    var fontButtons: [FontSelectionButton]
    var colorButtons: [ColorSelectionButton]
    var colorModeButtons: [ColorModeButton]
    var slider: SizeSlider
    var currentTextableLabelView: TextableLabelView? {
        didSet {
            for button in fontButtons {
                button.cancelHighLight()
                if button.titleLabel?.font.familyName == currentTextableLabelView?.label.font.familyName {
                    button.shouldBeHighlighted()
                }
            }
            for button in colorButtons {
                button.cancelHighLight()
                if button.backgroundColor == currentTextableLabelView?.label.textColor {
                    button.shouldBeHighlighted()
                }
            }
            for button in colorModeButtons {
                button.cancelHighLight()
                if button.colorState == currentTextableLabelView?.label.colorState {
                    button.shouldBeHighlighted()
                }
            }
        }
    }
    
    func handleTapEvent(for view: GestureRespondable) {
        
        switch view {
            
        case is TextableLabelView:
            let textableView = view as! TextableLabelView
            currentTextableLabelView = textableView
            currentTextableLabelView?.label.colorState = .foregroundMode
            
        case is FontSelectionButton:
            guard let label = currentTextableLabelView?.label else {return}
            
            let button = view as! FontSelectionButton
            guard let fontFamilyName = button.titleLabel?.font.familyName else {return}
            changeTextOutlooks(with: .changeFontStyle(fontFamilyName), for: label)
            
            checkHighlight(for: button, compareWith: .fontButtons(fontButtons))
            
        case is ColorSelectionButton:
            guard let label = currentTextableLabelView?.label else {return}
            
            let button = view as! ColorSelectionButton
            guard let color = button.backgroundColor else {return}
            
            switch label.colorState {
                
            case .foregroundMode:
                changeTextOutlooks(with: .changeForegroundColor(color), for: label)
            case .strokeMode:
                changeTextOutlooks(with: .changeStrokeColor(color), for: label)
            case .shadowMode:
                changeTextOutlooks(with: .changeShadow(color), for: label)
            }
            
            checkHighlight(for: button, compareWith: .colorButtons(colorButtons))
            
        case is SizeSlider:
            guard let label = currentTextableLabelView?.label else {return}
            
            let silder = view as! SizeSlider
            let value = CGFloat(silder.value)
            
            switch label.colorState {
            case .strokeMode:
                let width = -(value / 10)
                label.currentStringAttributes.updateValue(width, forKey: NSAttributedString.Key.strokeWidth)
                label.attributedText = NSAttributedString(string: "\(label.text ?? "")", attributes: label.currentStringAttributes)
                label.sizeToFit()
            case .shadowMode:
                label.layer.shadowRadius = value / 10
            case .foregroundMode:
                let ratio: CGFloat = (value / 100) * 3
                currentTextableLabelView?.transform = CGAffineTransform.init(scaleX: ratio, y: ratio)
            }
        case is ColorModeButton:
            guard let label = currentTextableLabelView?.label else {return}
            
            let button = view as! ColorModeButton
            label.colorState = button.colorState
            checkHighlight(for: button, compareWith: .colorModeButtons(colorModeButtons))
            
            switch label.colorState {
            case .foregroundMode:
                for button in colorButtons {
                    button.cancelHighLight()
                    if button.backgroundColor == label.currentStringAttributes[NSAttributedString.Key.foregroundColor] as? UIColor {
                        button.shouldBeHighlighted()
                    }
                }
            case .strokeMode:
                for button in colorButtons {
                    button.cancelHighLight()
                    if button.backgroundColor == label.currentStringAttributes[NSAttributedString.Key.strokeColor] as? UIColor {
                        button.shouldBeHighlighted()
                    }
                }
            case .shadowMode:
                for button in colorButtons {
                    button.cancelHighLight()
                    if button.backgroundColor?.cgColor == label.layer.shadowColor {
                        button.shouldBeHighlighted()
                    }
                }
                break
            }
            
        default:
            break
        }
    }
    
    func handlePanEvent(for view: GestureRespondable) {
        if let textableLabelView = view as? TextableLabelView {
            currentTextableLabelView = textableLabelView
            currentTextableLabelView?.label.colorState = .foregroundMode
        }
    }
    
    func colorStateeDidChange(from button: ColorModeButton) {
        currentTextableLabelView?.label.colorState = button.colorState
    }
    
    //the following two functions below(getSubViewOrigins and didSlideSubViews) handles textableLabelView slide logic while tapping the slidableMainButton
    func getSubViewOrigins(of imageView: UIImageView) -> [UIView: (CGFloat, CGFloat)]{
        var subViewOrigins = [UIView: (CGFloat, CGFloat)]()
        
        let currentImageRect = imageView.getImageRect()
        let frameOffsetX = currentImageRect.origin.x - imageView.frame.origin.x
        let frameOffsetY = currentImageRect.origin.y - imageView.frame.origin.y
        
        for view in imageView.subviews {
            let origin = (view: view.frame.origin.x - frameOffsetX, view.frame.origin.y - frameOffsetY)
            subViewOrigins.updateValue(origin, forKey: view)
        }
        return subViewOrigins
    }
    
    func didSlideSubViews(of imageView: UIImageView, from imageFrame: CGRect, from origins: [UIView: (CGFloat, CGFloat)]) {
        let currentImageRect = imageView.getImageRect()
        let ratio = fmin(currentImageRect.width / imageFrame.width, currentImageRect.height / imageFrame.height)
        for view in imageView.subviews {
            view.transform = view.transform.scaledBy(x: ratio, y: ratio)
            guard let (newOriginX, newOriginY) = origins[view] else {return}
            let newOffsetX = currentImageRect.origin.x - imageView.frame.origin.x
            let newOffsetY = currentImageRect.origin.y - imageView.frame.origin.y
            view.frame = CGRect(x: newOriginX * ratio + newOffsetX, y: newOriginY * ratio + newOffsetY, width: view.frame.width, height: view.frame.height)
        }
    }
    
    private func changeTextOutlooks(with attribute: TextAttribute, for label: AttributedLabel) {
        
        switch attribute {
            
        case .changeText(let newText):
            label.attributedText = NSAttributedString(string: newText, attributes: label.currentStringAttributes)
            label.sizeToFit()
            
        case .changeFontStyle(let newFontStyle):
            let size = label.font.pointSize
            guard let newFont = UIFont(name: newFontStyle, size: size) else {return}
            label.currentStringAttributes.updateValue(newFont, forKey: NSAttributedString.Key.font)
            label.attributedText = NSAttributedString(string: "\(label.text ?? "")", attributes: label.currentStringAttributes)
            label.sizeToFit()
            
        case .changeSize(let newSize):
            label.transform = CGAffineTransform(scaleX: newSize, y: newSize)
            label.sizeToFit()
            
        case .changeForegroundColor(let newColor):
            label.currentStringAttributes.updateValue(newColor, forKey: NSAttributedString.Key.foregroundColor)
            label.attributedText = NSAttributedString(string: "\(label.text ?? "")", attributes: label.currentStringAttributes)
            label.sizeToFit()
            
        case .changeStrokeColor(let newColor):
            label.currentStringAttributes.updateValue(newColor, forKey: NSAttributedString.Key.strokeColor)
            label.currentStringAttributes.updateValue(-3.0, forKey: NSAttributedString.Key.strokeWidth)
            label.attributedText = NSAttributedString(string: "\(label.text ?? "")", attributes: label.currentStringAttributes)
            label.sizeToFit()
            
        case .changeShadow(let newColor):
            label.layer.shadowColor = newColor.cgColor
            label.layer.shadowOpacity = 3
            label.layer.shadowRadius = 5
            label.layer.shadowOffset = CGSize(width: 0, height: 0)
            label.sizeToFit()
        }
    }
    
    private func checkHighlight<T: ViewInteractable>(for button: T, compareWith target: HighlightCompareTarget) where T: UIButton{
        let compareButtons = target.getCurrentCompareTargets()
        for button in compareButtons {
            button.cancelHighLight()
        }
        button.shouldBeHighlighted()
    }
    
    private enum TextAttribute {
        case changeText(String)
        case changeFontStyle(String)
        case changeSize(CGFloat)
        case changeForegroundColor(UIColor)
        case changeStrokeColor(UIColor)
        case changeShadow(UIColor)
    }
    
    private enum HighlightCompareTarget{
        case fontButtons([FontSelectionButton])
        case colorButtons([ColorSelectionButton])
        case colorModeButtons([ColorModeButton])
        
        func getCurrentCompareTargets() -> [ViewInteractable] {
            switch self {
            case .fontButtons(let buttons):
                return buttons
            case .colorButtons(let buttons):
                return buttons
            case .colorModeButtons(let buttons):
                return buttons
            }
        }
    }
    
    init(fontButtonContainerView: FontButtonContainerView, colorButtonContainerView: ColorButtonContainerView, slider: SizeSlider, colorModeButtons: [ColorModeButton]) {
        
        let fontButtons = fontButtonContainerView.returnSubviews().map( {$0 as! FontSelectionButton} )
        let colorButtons = colorButtonContainerView.returnSubviews().map( {$0 as! ColorSelectionButton} )
        
        self.fontButtons = fontButtons
        self.colorButtons = colorButtons
        self.slider = slider
        self.colorModeButtons = colorModeButtons
    }
    
}
