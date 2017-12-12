//
//  GameSound.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 25/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox.AudioServices

class GameSound {
    private static let explosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true)
    private static let shotSoundAction = SKAction.playSoundFileNamed("shot.wav", waitForCompletion: true)
    private static let bulletHitSoundAction = SKAction.playSoundFileNamed("bulletHit.wav", waitForCompletion: true)
    private static let emptyWeaponSoundAction = SKAction.playSoundFileNamed("emptyWeapon.wav", waitForCompletion: true)

    // -------------------------------------------------------------------------
    // MARK: - Vibrate

    static func vibrate() {
        #if os(iOS)
            
        rbDebug("GameSound: execute vibrate")
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

        #endif
    }

    // -------------------------------------------------------------------------
    // MARK: - Sound effects
    
    static func explosion(_ node: SKNode) {
        rbDebug("GameSound: play explosion")

        node.run(explosionSoundAction)
        GameSound.vibrate()
    }
    
    // -------------------------------------------------------------------------
    
    static func shot(_ node: SKNode) {
        rbDebug("GameSound: play shot")

        node.run(shotSoundAction)
    }
    
    // -------------------------------------------------------------------------
    
    static func bulletHit(_ node: SKNode) {
        rbDebug("GameSound: play bullet-hit")
        
        node.run(bulletHitSoundAction)
        GameSound.vibrate()
    }
    
    // -------------------------------------------------------------------------
    
    static func emptyWeapon(_ node: SKNode) {
        rbDebug("GameSound: play weapon-empty")
        
        node.run(emptyWeaponSoundAction)
    }

    // -------------------------------------------------------------------------
    // MARK: - Preload sounds

    static func preload() {
        rbDebug("GameSound: Preload sounds")
        
        let _ = explosionSoundAction
        let _ = shotSoundAction
        let _ = bulletHitSoundAction
        let _ = emptyWeaponSoundAction
    }

    // -------------------------------------------------------------------------

}
