//
//  GameHUD.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 24/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import SpriteKit

class GameHUD : GameElement {
    private var _node = SKNode()
    
    private var _health = HealthBar(size: CGSize.make(100, 10))
    private var _score = SKLabelNode()

    private var _bullets: ItemImageBar?
    private var _rockets: ItemImageBar?
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var score: Int {
        get {
            return Int(_score.text!)!
        }
        set(value) {
            _score.text = String(format: "%05d", value)
            _score.run(pulseAction)
        }
    }
    
    // -------------------------------------------------------------------------
    
    var health: Int {
        get {
            return _health.value
        }
        set(value) {
            _health.value = value
            
            _health.removeAllActions()
            
            if value <= 20 {
                _health.run(SKAction.repeatForever(pulseAction))
            }
        }
    }
    
    // -------------------------------------------------------------------------
    
    var bullets: Int {
        get {
            return _bullets!.value
        }
        set(value) {
            _bullets!.value = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var rockets: Int {
        get {
            return _rockets!.value
        }
        set(value) {
            _rockets!.value = value
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - HUD

    func sumUp(bulletPoints: Int, rocketPoints: Int) {
        // TODO: Sum up values animated
    }

    // -------------------------------------------------------------------------

    func reset(score: Int, health: Int, bullets: Int, rockets: Int) {
        if _bullets != nil {
            _bullets?.removeFromParent()
        }
        
        _bullets = ItemImageBar("itemBullet", total: bullets, factor: 5)
        _bullets!.position = CGPoint(x: scene.frame.midX-10-_bullets!.width, y: scene.frame.midY-20)
        _bullets!.zPosition = 100
        _node.addChild(_bullets!)
        
        if _rockets != nil {
            _rockets?.removeFromParent()
        }
        
        _rockets = ItemImageBar("rocket", total: rockets)
        _rockets!.position = CGPoint(x: scene.frame.midX-10-_rockets!.width, y: scene.frame.midY-40)
        _rockets!.zPosition = 100
        _node.addChild(_rockets!)
        
        self.score = score
        self.health = health
        self.bullets = bullets
        self.rockets = rockets
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Game methods
    
    func gameOver() {
        let label = SKLabelNode()
        label.text = "GAME OVER"
        label.fontName = "HelveticaNeue-Bold"
        label.fontSize = 40
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 0)
        label.zPosition = 100
        _node.addChild(label)
        
        label.run(pulseAction)
        
        _health.removeAllActions()
    }
    
    // -------------------------------------------------------------------------
    
    func gameWin() {
        let label = SKLabelNode()
        label.text = "YOU WIN!"
        label.fontName = "HelveticaNeue-Bold"
        label.fontSize = 40
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 0)
        label.zPosition = 100
        _node.addChild(label)

        label.run(pulseAction)

        _health.removeAllActions()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(addTo scene: GameScene) {
        super.init(scene: scene)
        
        scene.camera?.addChild(_node)

        let background = SKSpriteNode()
        background.size = CGSize.make(scene.frame.size.width, 60)
        background.color = UIColor.black
        background.alpha = 0.05
        background.position = CGPoint(x: 0, y: scene.frame.midY-30)
        background.zPosition = 100
       _node.addChild(background)
        
        _score.fontName = "HelveticaNeue-Bold"
        _score.fontSize = 20
        _score.horizontalAlignmentMode = .left
        _score.position = CGPoint(x: -scene.frame.midX+20, y: scene.frame.midY-30)
        _score.zPosition = 100
        _node.addChild(_score)

        _health.zPosition = 100
        _health.position = CGPoint(x: -scene.frame.midX+20, y: scene.frame.midY-40)
        _node.addChild(_health)
    }

    // -------------------------------------------------------------------------

}
