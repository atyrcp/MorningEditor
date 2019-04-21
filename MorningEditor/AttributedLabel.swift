//
//  AttributedLabel.swift
//  MorningEditor
//
//  Created by alien on 2019/4/3.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class AttributedLabel: UILabel {
    
    var currentStringAttributes =  [NSAttributedString.Key : Any]()
    var colorState = ColorState.foregroundMode
    
    private func setupViews() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        self.numberOfLines = 1
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
