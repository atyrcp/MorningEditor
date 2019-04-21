//
//  AttributedSlider.swift
//  MorningEditor
//
//  Created by alien on 2019/4/2.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class SizeSlider: UISlider, Slidable, GestureRespondable {
    
    var delegate: GestureRespondDelegate?
    var didSlide = true
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.minimumTrackTintColor = .customCgBlue
        self.maximumTrackTintColor = .clear
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
