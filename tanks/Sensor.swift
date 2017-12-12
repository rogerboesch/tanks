//
//  Sensor.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 23/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import SpriteKit

class Sensor : GameElement {
    private var _node: SpriteElement?
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(addTo scene: GameScene, position: CGPoint, height: CGFloat = 100.0) {
        super.init(scene: scene)
        
        self.name = "Sensor"
        
        // Create rocket node
        _node = SpriteElement(color: UIColor.red, size: CGSize.make(10, height))
        _node!.element = self
        _node!.name = "Sensor"
        _node!.position =  position
        _node!.physicsBody = SKPhysicsBody(rectangleOf: CGSize.make(10, height))
        _node!.physicsBody!.isDynamic = false
        _node!.physicsBody!.categoryBitMask = GameElementCategory.sensor.rawValue
        _node!.physicsBody!.contactTestBitMask = GameElementCategory.player.rawValue | GameElementCategory.enemy.rawValue
        _node!.physicsBody!.collisionBitMask = GameElementCategory.none.rawValue
        scene.world.addChild(_node!)
    }
    
    // -------------------------------------------------------------------------
    
}
