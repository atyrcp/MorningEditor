//
//  TextableLabelView.swift
//  MorningEditor
//
//  Created by alien on 2019/4/5.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class TextableLabelView: UIView, UITextFieldDelegate, ViewInteractable, Pannable, Pinchable, Slidable {
    
    var label = AttributedLabel()
    var textField = UITextField()
    var delegate: GestureRespondDelegate?
    var didSlide = true
    var isInTextMode = false
    
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self.superview)
        self.center.x += translation.x
        self.center.y += translation.y
        panGesture.setTranslation(.zero, in: self.superview)
        label.sizeToFit()
        
        switch panGesture.state {
        case .began:
            delegate?.didSelect(in: self, for: .pan)
        default:
            break
        }
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        textField.attributedText = label.attributedText
        
        isInTextMode = true
        delegate?.didSelect(in: self, for: .tap)
        
        label.attributedText = nil
        self.bringSubviewToFront(textField)
        textField.becomeFirstResponder()
    }
    
    func handlePinchGesture(pinchGesture: UIPinchGestureRecognizer) {
        guard let scaleX = pinchGesture.scale(view: self)?.x, let scaleY = pinchGesture.scale(view: self)?.y else {return}
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        self.label.sizeToFit()
        layoutIfNeeded()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        label.attributedText = textField.attributedText
        
        isInTextMode = false
        delegate?.didSelect(in: self, for: .tap)
        
        textField.attributedText = nil
        label.sizeToFit()
        self.bringSubviewToFront(label)
        textField.resignFirstResponder()
        return true
    }
    
    private func setupViews() {
        self.addTapGesture()
        self.addPanGesture()
        self.addPinchGesture()
        addSubview(label)
        addSubview(textField)
        bringSubviewToFront(label)
        
        label.attributedText = NSAttributedString(string: "請在這裡輸入文字", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.delegate = self
        textField.adjustsFontSizeToFitWidth = true
        textField.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        
        self.bounds = label.bounds
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
}
