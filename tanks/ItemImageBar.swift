//
//  ItemImageBar.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 24/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import SpriteKit

class ItemImageBar : SKNode {
    private var _totalValue: CGFloat = 0.0
    private var _currentValue: CGFloat = 0.0
    private var _factor: CGFloat = 1.0
    private var _width: CGFloat = 0.0
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var width: CGFloat {
        get {
            return _width
        }
    }
    
    // -------------------------------------------------------------------------
    
    var total: Int {
        get {
            return Int(_totalValue)
        }
    }
    
    // -------------------------------------------------------------------------

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
        let myTotal = Int(_totalValue / _factor)
        var myValue = Int(_currentValue / _factor)
        
        if _factor > 1 {
            if Int(_currentValue) % Int(_factor) != 0 {
                myValue += 1
            }
        }
        
        for i in 1...myTotal {
            let number = myTotal - i + 1
            
            if let sprite = self.childNode(withName: "\(number)") {
                if myValue >= i {
                    sprite.alpha = 1.0
                }
                else {
                    sprite.alpha = 0.2
                }
            }
            else {
                rbError("ItemImageBar: Cant find child node \(number)")
                return
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(_ name: String, total: Int, factor: Int = 1) {
        super.init()
        
        _totalValue = CGFloat(total)
        _factor = CGFloat(factor)
        
        if let image = UIImage(named: name) {
            let texture = SKTexture(image: image)

            _width = 0

            let myTotal = total / factor
            var x: CGFloat = 0

            for i in 1...myTotal {
                let sprite = SKSpriteNode(texture: texture)
                sprite.name = "\(i)"
                sprite.position = CGPoint(x: x, y: 0)
                self.addChild(sprite)


                x = x + sprite.size.width + 3

                _width = x - sprite.size.width/2
            }
        }
        else {
            rbError("ItemBar: image \(name) not found")
        }
   }
    
    // -------------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // -------------------------------------------------------------------------
    
}
