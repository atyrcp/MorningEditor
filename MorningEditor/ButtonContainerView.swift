//
//  LabelContainerView.swift
//  MorningEditor
//
//  Created by alien on 2019/3/28.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class ButtonContainerView: UIView, ButtonLayoutable, Slidable {
    
    var needLayoutButtons = [UIButton]()
    var needLayoutStackViews = [UIStackView]()
    var didSlide = true
    
    func layoutButtons() {
        
        var currentLabelStackView = UIStackView()
        currentLabelStackView.axis = .horizontal
        currentLabelStackView.alignment = .fill
        currentLabelStackView.distribution = .fillEqually
        currentLabelStackView.spacing = 8
        
        for label in needLayoutButtons {
            if currentLabelStackView.subviews.count < 5 {
                currentLabelStackView.addArrangedSubview(label)
            } else {
                needLayoutStackViews.append(currentLabelStackView)
                
                let newLabelStackView = UIStackView()
                newLabelStackView.axis = .horizontal
                newLabelStackView.alignment = .fill
                newLabelStackView.distribution = .fillEqually
                newLabelStackView.spacing = 8
                
                currentLabelStackView = newLabelStackView
                currentLabelStackView.addArrangedSubview(label)
            }
        }
        needLayoutStackViews.append(currentLabelStackView)
    }
    
    func layoutStackViews() {
        let stackview = UIStackView(arrangedSubviews: needLayoutStackViews)
        stackview.axis = .vertical
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        stackview.spacing = 8
        
        self.addSubview(stackview)
        
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        stackview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        stackview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        stackview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    }
    
    func returnSubviews() -> [UIView] {
        var subviewArray = [UIView]()
        for view in self.subviews {
            for stackview in view.subviews {
                for button in stackview.subviews {
                    subviewArray.append(button)
                }
            }
        }
        return subviewArray
    }
    
    private func setupViews() {
        self.backgroundColor = .customLavenderGray
    }
    
    override func layoutSubviews() {
        let subviewArray = returnSubviews()
        subviewArray.forEach( { $0.cutCorner(to: $0.frame.height / 5) } )
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



class FontButtonContainerView: ButtonContainerView, ButtonCreatable {
    typealias Source = String
    var source = ["HanWangWCL02", "HanWangWCL03", "HanWangWCL05", "HanWangWCL07", "HanWangMingMedium", "HanWangYenHeavy", "HanWangLiSuMedium", "HanWangShinSuMedium", "HanWang-KaiBold-Gb5", "HanWang-FangSongMedium-Gb5"]
    
    func createButtonFromSource() {
        
        for index in 0...source.count - 1 {
            let button = FontSelectionButton()
            let title = NSAttributedString(string: "字體\(index + 1)", attributes: [NSAttributedString.Key.font: UIFont(name: source[index], size: 16)!])
            
            button.titleLabel?.textColor = UIColor.customOuterSpace
            button.setAttributedTitle(title, for: .normal)
            button.contentHorizontalAlignment = .center
            button.sizeToFit()
            
            needLayoutButtons.append(button)
        }
    }
    
    private func setupViews() {
        createButtonFromSource()
        layoutButtons()
        layoutStackViews()
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

class ColorButtonContainerView: ButtonContainerView, ButtonCreatable {
    typealias Source = UIColor
    var source: [UIColor] = [.black, .darkGray, .white, .brown, .red, .orange, .yellow, .green, .blue, .purple]
    
    func createButtonFromSource() {
        for index in 0...source.count - 1 {
            let button = ColorSelectionButton()
            button.backgroundColor = source[index]
            
            needLayoutButtons.append(button)
        }
        
    }
    
    private func setupViews() {
        createButtonFromSource()
        layoutButtons()
        layoutStackViews()
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
