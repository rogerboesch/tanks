//
//  GameViewController.swift
//  Platform(s): tvOS
//
//  Created by Roger Boesch on 24/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    private var _level: GameScene?
    
    // -------------------------------------------------------------------------
    // MARK: - Level transition
    
    private func levelTransition() {
        if let view = self.view as? SKView {
            // Create scene (level)
            _level = GameScene(size: self.view.bounds.size)
            _level!.scaleMode = .resizeFill
            
            let transition = SKTransition.doorway(withDuration: 2.0)
            view.presentScene(_level!, transition: transition)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Gesture handling
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        if _level!.isFinished {
            levelTransition()
        }
        else {
            _level!.handleGameKey(.fire)
        }
    }
    
    // -------------------------------------------------------------------------
    
    func handlePlay(_ gestureRecognize: UIGestureRecognizer) {
        if _level!.isFinished {
            levelTransition()
        }
        else {
            _level!.handleGameKey(.fire)
        }
    }
    
    // -------------------------------------------------------------------------
    
    func handleSwipe(_ gestureRecognize: UISwipeGestureRecognizer) {
        if (gestureRecognize.direction == .left) {
            rbDebug("Handle swipe left")
            _level!.handleGameKey(.left)
        }
        else if (gestureRecognize.direction == .right) {
            rbDebug("Handle swipe right")
            _level!.handleGameKey(.right)
        }
        else if (gestureRecognize.direction == .up) {
            rbDebug("Handle swipe up")
            _level!.handleGameKey(.up)
        }
        else if (gestureRecognize.direction == .down) {
            rbDebug("Handle swipe down")
            _level!.handleGameKey(.down)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - View life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GameSound.preload()
    }
    
    // -------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create scene (level)
        _level = GameScene(size: self.view.bounds.size)
        _level!.scaleMode = .resizeFill
        
        // Create view
        let view = SKView()
        self.view = view
        view.presentScene(_level!)
        
        view.showsFPS = true
        view.showsNodeCount = true
        view.ignoresSiblingOrder = false
        view.showsPhysics = false
        
        // Add gestures
        let playRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePlay(_:)))
        playRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue)]
        self.view.addGestureRecognizer(playRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUpGesture.direction = .up
        view.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    // -------------------------------------------------------------------------
    
}
