//
//  ParallaxBackground.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 24/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import SpriteKit

class ParallaxBackground : GameElement {
    private var _node: SKSpriteNode?
    private var _layer1: SKSpriteNode?
    private var _layer2: SKSpriteNode?
    private var _layer3: SKSpriteNode?
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var node: SKNode {
        get {
            return _node!
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Game element overrides
    
    override func update() {
        // Adjust main node to camera
        _node?.position = self.scene.camera!.position
        
        // Scroll layer nodes
        //let cameraOffset = self.scene.camera!.position.x
        //let gameWidth = self.scene.widthOfGame
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Image manipulation
    
    private func resizeImage(_ image: UIImage?) -> UIImage? {
        if image == nil {
            return nil
        }

        let screenWidth = self.scene.size.width
        let scale = screenWidth / image!.size.width
        let newHeight = image!.size.height * scale

        #if os(iOS) || os(tvOS)


        UIGraphicsBeginImageContext(CGSize.make(screenWidth, newHeight))
        image!.draw(in: CGRect.make(0, 0, screenWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
        #else
        
        let newImage = resize(image: image!, w: Int(screenWidth), h: Int(newHeight))
        return newImage
            
        #endif
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(addTo scene: GameScene, imageLayer1Named name1: String, imageLayer2Named name2: String, imageLayer3Named name3: String) {
        super.init(scene: scene)

        let screenWidth = self.scene.size.width

        _node = SKSpriteNode(color: UIColor.clear, size: CGSize.make(100, 100))
        scene.world.addChild(_node!)
        
        // Create layer 1
        _layer1 = SKSpriteNode(color: UIColor.clear, size: CGSize.make(80, 80))
        _node!.addChild(_layer1!)
        
        if let image = resizeImage(RBImage.getImage(named: name1)) {
            let texture = SKTexture(image: image)
            var x = -(screenWidth/2.0)
            
            for i in 1...2 {
                let sprite = SKSpriteNode(texture: texture)
                sprite.name = "1-\(i)"
                sprite.zPosition = -12
                sprite.position = CGPoint(x: x, y: 0)
                sprite.lightingBitMask = 1
                sprite.shadowedBitMask = 1
                _layer1!.addChild(sprite)
                
                x = x + screenWidth
            }
        }
        else {
            rbError("ParallaxBackground: Can't create layer 1, image \(name1) not found")
        }
        
        // Create layer 2
        _layer2 = SKSpriteNode(color: UIColor.clear, size: CGSize.make(60, 60))
        _node!.addChild(_layer2!)
        
        if let image = resizeImage(RBImage.getImage(named: name2)) {
            let texture = SKTexture(image: image)
            var x = -screenWidth
            
            for i in 1...3 {
                let sprite = SKSpriteNode(texture: texture)
                sprite.name = "2-\(i)"
                sprite.zPosition = -11
                sprite.position = CGPoint(x: x, y: 0)
                sprite.lightingBitMask = 1
                sprite.shadowedBitMask = 1
                _layer2!.addChild(sprite)
                
                x = x + screenWidth
            }
        }
        else {
            rbError("ParallaxBackground: Can't create layer 2, image \(name2) not found")
        }
        
        // Create layer 3
        _layer3 = SKSpriteNode(color: UIColor.clear, size: CGSize.make(40, 40))
        _node!.addChild(_layer3!)
        
        if let image = resizeImage(RBImage.getImage(named: name3)) {
            let texture = SKTexture(image: image)
            var x = -screenWidth
            
            for i in 1...3 {
                let sprite = SKSpriteNode(texture: texture)
                sprite.name = "3-\(i)"
                sprite.zPosition = -10
                sprite.position = CGPoint(x: x, y: 0)
                sprite.lightingBitMask = 1
                sprite.shadowedBitMask = 1
                _layer3!.addChild(sprite)
                
                x = x + screenWidth
            }
        }
        else {
            rbError("ParallaxBackground: Can't create layer 3, image \(name3) not found")
        }
    }
    
    // -------------------------------------------------------------------------
}
