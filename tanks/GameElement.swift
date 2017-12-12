//
//  GameElement.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 22/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import SpriteKit

// Virtual game key
enum GameKey {
    case left, right, up, down, fire
}

// State's of a game scene
enum GameState {
    case none, intro, run, win, loose, paused
}

// State's of a game element
enum GameElementState {
    case none, idle, moving, paused, stopped, willDie, dead, unused
}

// Direction of a game element
enum GameElementDitrection {
    case none, left, right
}

// Game element categorys (used for physics)
enum GameElementCategory : UInt32 {
    case none    = 0x00000000
    case player  = 0x00000001
    case enemy   = 0x00000010
    case weapon  = 0x00000100
    case terrain = 0x00001000
    case sensor  = 0x00010000
}

class GameElement {
    private static var counter = 0
    
    private var _number = 0
    private var _name = "GameElement"
    private var _state: GameElementState = .none
    private var _scene: GameScene
    private var _direction: GameElementDitrection = .none
    
    private var _labelNode = SKLabelNode()
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var name: String {
        get {
            return "\(_name) (id:\(_number)"
        }
        set(value) {
            _name = value
            _labelNode.text = self.description
        }
    }

    // -------------------------------------------------------------------------

    var description: String {
        get {
            return "\(_name) (id:\(_number),\(self.state))"
        }
    }

    // -------------------------------------------------------------------------

    var number: Int {
        get {
            return _number
        }
    }
    
    // -------------------------------------------------------------------------
    
    var state: GameElementState {
        get {
            return _state
        }
        set(value) {
            _state = value
            _labelNode.text = self.description
        }
    }
    
    // -------------------------------------------------------------------------
    
    var direction: GameElementDitrection {
        get {
            return _direction
        }
        set(value) {
            _direction = value
        }
    }
    
    // -------------------------------------------------------------------------

    var scene: GameScene {
        get {
            return _scene
        }
    }
 
    // -------------------------------------------------------------------------

    var isDead: Bool {
        get {
            if self.state == .willDie {
                return true
            }
            
            if self.state == .dead {
                return true
            }
            
            if self.state == .unused {
                return true
            }
            
            return false
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Label node (Info or or debugging)
    
    func activateLabel(parent: SKNode) {
#if DEBUG
    
        _labelNode.isHidden = false
        _labelNode.text = self.description
        _labelNode.fontName = "HelveticaNeue-Bold"
        _labelNode.fontSize = 14
        _labelNode.position = CGPoint.make(0, 40)

        parent.addChild(_labelNode)
        
#endif
    }

    // -------------------------------------------------------------------------
    // MARK: - Actions

    func update() {}
    func start() {}
    func stop() {}
    func pause() {}
    func kill() {}
    func collide(with element: GameElement, point: CGPoint) {}
    func run(_ action: SKAction) {}
    
    // -------------------------------------------------------------------------
    
    init(scene: GameScene) {
        _scene = scene
        
        GameElement.counter += 1
        _number = GameElement.counter

        _labelNode.isHidden = true
    }
    
    // -------------------------------------------------------------------------

}

// -----------------------------------------------------------------------------
// MARK: - Helper classes to assign game elements to SpriteKit nodes

protocol GameElementNode {
    var element: GameElement? {get}
}

class SpriteElement : SKSpriteNode, GameElementNode {
    private var _element: GameElement?
    
    var element: GameElement? {
        get {
            return _element
        }
        set(value) {
            _element = value
        }
    }
    
}

class ShapeElement : SKShapeNode, GameElementNode {
    private var _element: GameElement?
    
    var element: GameElement? {
        get {
            return _element
        }
        set(value) {
            _element = value
        }
    }
    
}
