//
//  GameViewController.swift
//  Platform(s): iOS
//
//  Created by Roger Boesch on 20/10/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
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
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        if _level!.isFinished {
            levelTransition()
        }
        else {
            _level!.handleGameKey(.fire)
        }
    }
    
    // -------------------------------------------------------------------------
    
    @objc func handleSwipe(_ gestureRecognize: UISwipeGestureRecognizer) {
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
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

    override var shouldAutorotate: Bool {
        return true
    }
    // -------------------------------------------------------------------------

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    // -------------------------------------------------------------------------

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // -------------------------------------------------------------------------

}
