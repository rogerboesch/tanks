//
//  GameHelper.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 22/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import SpriteKit

// -----------------------------------------------------------------------------
// MARK: - Produce shockwave's

let shockWaveAction: SKAction = {
    let growAndFadeAction = SKAction.group([SKAction.scale(to: 50, duration: 0.5), SKAction.fadeOut(withDuration: 0.5)])
    let sequence = SKAction.sequence([growAndFadeAction, SKAction.removeFromParent()])
    
    return sequence
}()

// -----------------------------------------------------------------------------

func runShockWave(at point: CGPoint, scene: GameScene) {
    let shockwave = SKShapeNode(circleOfRadius: 1)
    shockwave.position = point
    scene.addChild(shockwave)
    shockwave.run(shockWaveAction)
}

// -----------------------------------------------------------------------------
// MARK: - Standard action for grow and shrink

let pulseAction: SKAction = {
    let growAction = SKAction.scale(to: 1.4, duration: 0.1)
    let shrinkAction = SKAction.scale(to: 1.0, duration: 0.1)
    let sequence = SKAction.sequence([growAction, shrinkAction])
    
    return sequence
}()

// -----------------------------------------------------------------------------
// MARK: - Glow effect

extension SKSpriteNode {
    
    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
    }
}

// -----------------------------------------------------------------------------
