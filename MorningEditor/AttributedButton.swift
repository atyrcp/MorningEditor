//
//  AttributeButton.swift
//  MorningEditor
//
//  Created by alien on 2019/4/1.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class MainButton: UIButton {
    
    private func setupView() {
        self.backgroundColor = .customDeepSpaceSparkle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

class SlidableMainButton: MainButton, Slidable {
    var didSlide = true
    
    private func setupViews() {
        self.backgroundColor = .customCgBlue
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

class RoundedMainButton: MainButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cutCorner(to: self.frame.height / 5)
        
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        titleLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        titleLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2).isActive = true
        titleLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true
        titleLabel?.numberOfLines = 1
        titleLabel?.textAlignment = .center
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

@IBDesignable
class ColorModeButton: RoundedMainButton, ViewInteractable {
    
    var delegate: GestureRespondDelegate?
    var colorState: ColorState = .foregroundMode
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        delegate?.didSelect(in: self, for: .tap)
    }
    
    @IBInspectable var changeColorState: Int {
        get {
            return self.colorState.rawValue
        } set {
            self.colorState = ColorState(rawValue: newValue) ?? .foregroundMode
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class AttributedButton: UIButton, Slidable {
    var didSlide = false
    
    private func setupViews() {
        self.backgroundColor = .clear
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

class FontSelectionButton: AttributedButton, ViewInteractable {
    
    weak var delegate: GestureRespondDelegate?
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        delegate?.didSelect(in: self, for: .tap)
    }
    
    func shouldBeHighlighted() {
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.customOuterSpace.cgColor
    }
    
    func cancelHighLight() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func setupViews() {
        self.addTapGesture()
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

class ColorSelectionButton: AttributedButton, ViewInteractable {
    
    weak var delegate: GestureRespondDelegate?
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        delegate?.didSelect(in: self, for: .tap)
    }
    
    private func setupViews() {
        self.addTapGesture()
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


