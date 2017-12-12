//
//  HealthBar.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 24/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import SpriteKit

class HealthBar : SKNode {
    private var _fullBar: SKSpriteNode?
    private var _valueBar: SKSpriteNode?
    
    private var _color100 = UIColor.green
    private var _color50 = UIColor.orange
    private var _color20 = UIColor.red
    
    private var _fullValue: CGFloat = 100.0
    private var _currentValue: CGFloat = 78.0
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var value: Int {
        get {
            return Int(_currentValue)
        }
        set(value) {
            _currentValue = CGFloat(value)
            updateSprite()
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Drawing
    
    private func updateSprite() {
        let width = _fullBar!.size.width / _fullValue * _currentValue
        _valueBar?.size = CGSize.make(width, _fullBar!.size.height)
        
        if _currentValue <= 20 {
            _fullBar?.color = _color20
            _valueBar?.color = _color20
        }
        else if _currentValue <= 50 {
            _fullBar?.color = _color50
            _valueBar?.color = _color50
        }
        else  {
            _fullBar?.color = _color100
            _valueBar?.color = _color100
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(size: CGSize) {
        super.init()
        
        _fullBar = SKSpriteNode(color: _color100, size: size)
        _fullBar?.alpha = 0.3
        _fullBar?.anchorPoint = CGPoint.make(0.0, 0.5)
        self.addChild(_fullBar!)
        
        _valueBar = SKSpriteNode(color: _color100, size: size)
        _valueBar?.anchorPoint = CGPoint.make(0.0, 0.5)
        self.addChild(_valueBar!)
    }
    
    // -------------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    // -------------------------------------------------------------------------

}
