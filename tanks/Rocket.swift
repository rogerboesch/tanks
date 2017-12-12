//
//  Rocket.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 21/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import SpriteKit

class Rocket : GameElement {
    
    private var _node: SpriteElement?
    
    private var _velocityX: CGFloat = 0
    private var _velocityY: CGFloat = 0
    private var _startTime: TimeInterval = 0
    private var _isFalling = false
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var position: CGPoint {
        get {
            return _node!.position
        }
        set(value) {
            _node!.position = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var node: SKNode {
        get {
            return _node!
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Game element overrides
    
    override func start() {
        _velocityX = 250
        _velocityY = 500
        _startTime = CFAbsoluteTimeGetCurrent()
        
        let action = SKAction.rotate(toAngle: CGFloat(60.0).toRadians(), duration: 0.1)
        _node?.run(action)
        
        self.state = .moving
        
    }
    
    // -------------------------------------------------------------------------
    
    override func stop() {
        _velocityX = 0
        _velocityY = 0
        
        _node?.removeAllActions()
        
        self.state = .stopped
    }
    
    // -------------------------------------------------------------------------
    
    override func kill() {
        _node?.removeAllActions()
        _node?.physicsBody = nil
        _node?.removeFromParent()
        _node = nil
    }
    
    // -------------------------------------------------------------------------
    
    override func update() {
        if self.state == .moving {
            let rate: CGFloat = 1.0
            let relativeVelocity: CGVector = CGVector(dx: _velocityX-_node!.physicsBody!.velocity.dx, dy: _velocityY-_node!.physicsBody!.velocity.dy)
            _node!.physicsBody?.velocity = CGVector(dx: _node!.physicsBody!.velocity.dx+relativeVelocity.dx*rate, dy: _node!.physicsBody!.velocity.dy+relativeVelocity.dy*rate)
 
            if CFAbsoluteTimeGetCurrent() - _startTime > 0.5 {
                if !_isFalling {
                    _velocityY = -500
                
                    let action = SKAction.rotate(toAngle: CGFloat(-60.0).toRadians(), duration: 0.2)
                    _node?.run(action)
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------
    
    override func collide(with element: GameElement, point: CGPoint) {
        if self.state != .moving {
            return
        }
        
        rbDebug("Rocket collides with \(element.name)")
        
        runShockWave(at: point, scene: self.scene)
        self.scene.shake()
        self.scene.flash()
   
        GameSound.explosion(self.scene.world)
        
        _node!.isHidden = true
        _node!.physicsBody!.isResting = true
        
        self.state = .unused
        
        // Check with what collision was
        if let tank = element as? Tank {
            if tank.isEnemy {
                tank.hit()
                tank.hit()
                
                self.scene.changeHealth(by: Game.Health.destroyTank)
                self.scene.changeScore(by: Game.Score.destroyTank)
            }
        }
        else if let _ = element as? Hill {
            let sprite = SKSpriteNode(imageNamed: "crater")
            sprite.alpha = 0.5
            sprite.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            sprite.position = point
            self.scene.addChild(sprite)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(addTo scene: GameScene, position: CGPoint) {
        super.init(scene: scene)

        self.name = "Rocket"

        // Create rocket node
        _node = SpriteElement(imageNamed: "rocket")
        _node!.element = self
        _node!.name = "Rocket"
        _node!.position = position
        _node!.xScale = 0.5
        _node!.yScale = 0.5
        _node!.physicsBody = SKPhysicsBody(rectangleOf: _node!.size)
        _node!.physicsBody!.affectedByGravity = true
        _node!.physicsBody!.allowsRotation = false
        _node!.physicsBody!.categoryBitMask = GameElementCategory.weapon.rawValue
        _node!.physicsBody!.contactTestBitMask = GameElementCategory.terrain.rawValue | GameElementCategory.player.rawValue | GameElementCategory.enemy.rawValue
        scene.world.addChild(_node!)
        
        _node!.lightingBitMask = 1
        _node!.shadowedBitMask = 1
    }
    
    // -------------------------------------------------------------------------
    
}
