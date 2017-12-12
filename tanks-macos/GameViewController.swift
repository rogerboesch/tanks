//
//  GameViewController.swift
//  Platform(s): macOS
//
//  Created by Roger Boesch on 04/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import SpriteKit
import QuartzCore

// -----------------------------------------------------------------------------
// MARK: - Subclassed to catch events

class GameView : SKView {
    var controller: GameViewController?
    
    override var acceptsFirstResponder : Bool { return true }
    override func becomeFirstResponder() -> Bool { return true }
    override func resignFirstResponder() -> Bool { return true }
    override func keyDown(with event: NSEvent) { controller?.keyDown(with: event) }
    
}

class GameViewController: NSViewController {
    @IBOutlet var skView: GameView!
    
    private var _level: GameScene?

    // -------------------------------------------------------------------------
    // MARK: - Level transition
    
    private func levelTransition() {
        if let view = self.view as? GameView {
            // Create scene (level)
            _level = GameScene(size: self.view.bounds.size)
            _level!.scaleMode = .resizeFill
            
            let transition = SKTransition.doorway(withDuration: 2.0)
            view.presentScene(_level!, transition: transition)
        }
    }

    // -------------------------------------------------------------------------
    
    override func keyDown(with event: NSEvent) {
        rbDebug("Key down: \(event.keyCode)")
        
        if _level!.isFinished {
            levelTransition()
            return
        }
        
        switch event.keyCode {
        // LEFT
        case 123:
            _level!.handleGameKey(.left)
        // RIGHT
        case 124:
            _level!.handleGameKey(.right)
        // UP
        case 126:
            _level!.handleGameKey(.up)
        // DOWN
        case 125:
            _level!.handleGameKey(.down)
        // SPACE
        case 49:
            _level!.handleGameKey(.fire)
        default:
            _ = 1
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Touchbar Support
    
    @IBAction func touchFire(sender: NSButton) {
        rbDebug("Fire key pressed on TouchBar")
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ViewController life cycle
    
    override func viewWillLayout() {
        super.viewWillLayout()
    }

    // -------------------------------------------------------------------------

    override func viewDidAppear() {
        super.viewDidAppear()

        GameSound.preload()
    }

    // -------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create scene (level)
        _level = GameScene(size: CGSize.make(windowSize.width, windowSize.height))
        _level!.scaleMode = .aspectFill
        
        if let view = self.skView {
            view.controller = self
            
            view.presentScene(_level!)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = false
        }
    }
    
    // -------------------------------------------------------------------------
    
}
