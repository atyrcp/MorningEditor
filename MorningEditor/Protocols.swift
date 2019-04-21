//
//  Protocols.swift
//  MorningEditor
//
//  Created by alien on 2019/3/27.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation
import UIKit

//protocol for containerView(an UIView), make it able to put some buttons in and do the layout
protocol ButtonCreatable {
    associatedtype Source
    var source: [Source] { get }
    
    func createButtonFromSource()
}

protocol ButtonLayoutable {
    var needLayoutButtons: [UIButton] { get }
    var needLayoutStackViews: [UIStackView] { get }
    
    func layoutButtons()
    func layoutStackViews()
}

protocol Slidable {
    var didSlide: Bool { get set }
    
    func slideIn(withMovement y: CGFloat)
    func slideOut(withMovement y: CGFloat)
}

extension Slidable where Self: UIView & Slidable {
    func slideIn(withMovement y: CGFloat) {
        UIView.animate(withDuration: 0.8) {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + y, width: self.frame.width, height: self.frame.height)
        }
    }
    
    func slideOut(withMovement y: CGFloat) {
        UIView.animate(withDuration: 0.8) {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - y, width: self.frame.width, height: self.frame.height)
        }
    }
}



// protocols for all views ( buttons and labels ) which should be tapped, notifying other object to handle this tap event
typealias ViewInteractable = GestureRespondable & Tappable & Highlightable

protocol GestureRespondable {
    var delegate: GestureRespondDelegate? { get }
}

@objc protocol Tappable {
    func handleTapGesture(tapGesture: UITapGestureRecognizer)
}

extension Tappable where Self: UIView {
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(tapGesture:)))
        self.addGestureRecognizer(tap)
    }
}

@objc protocol Pannable {
    func handlePanGesture(panGesture: UIPanGestureRecognizer)
}

extension Pannable where Self: UIView {
    func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        self.addGestureRecognizer(pan)
    }
}

@objc protocol Pinchable {
    func handlePinchGesture(pinchGesture: UIPinchGestureRecognizer)
}

extension Pinchable where Self: UIView {
    func addPinchGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(pinchGesture:)))
        self.addGestureRecognizer(pinch)
    }
}

// the object which conform to this protocol is responsible for handling the event (normally a tap event)
protocol GestureRespondDelegate: class {
    func didSelect(in view: GestureRespondable, for event: GestureEvent)
}



protocol Highlightable {
    func shouldBeHighlighted()
    func cancelHighLight()
}

extension Highlightable where Self: UIView {
    func shouldBeHighlighted() {
        self.alpha = 0.3
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.customOuterSpace.cgColor
    }
    
    func cancelHighLight() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.alpha = 1
    }
}
