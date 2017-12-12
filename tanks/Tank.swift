//
//  Tank.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 21/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import SpriteKit

// Angle, a tank's turrent can have
enum TurretAngle {
    case down, middle, up
}

class Tank : GameElement {
    private let waitTimeAfterCollide: TimeInterval = 3.0
    
    private let chassisSize = CGSize.make(60, 30)
    private let wheelOffsetY: CGFloat = 40
    private let damping: CGFloat = 0.5
    private let frequency: CGFloat = 4
    private let debugColor = UIColor.clear
    
    private var _vehicle: SKNode?
    private var _chassis: SpriteElement?
    private var _leftWheel: SpriteElement?
    private var _middleWheel: SpriteElement?
    private var _rightWheel: SpriteElement?
    private var _turret: SKSpriteNode?

    private var _velocity: CGFloat = 0
    private var _enemy = false

    private var _score: Int = 0
    private var _health: Int = 0
    private var _bullets: Int = 0
    private var _rockets: Int = 0
    
    private var _joints = Array<SKPhysicsJoint>()
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var position: CGPoint {
        get {
            return _chassis!.position
        }
        set(value) {
            _chassis!.position = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var node: SKNode {
        get {
            return _chassis!
        }
    }
    
    // -------------------------------------------------------------------------
    
    var health: Int {
        get {
            return _health
        }
    }
    
    // -------------------------------------------------------------------------
    
    var score: Int {
        get {
            return _score
        }
    }
    
    // -------------------------------------------------------------------------
    
    var rockets: Int {
        get {
            return _rockets
        }
    }
    
    // -------------------------------------------------------------------------
    
    var bullets: Int {
        get {
            return _bullets
        }
    }
    
    // -------------------------------------------------------------------------
    
    var isEnemy: Bool {
        get {
            return _enemy
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Point system
    
    func changeHealth(by points: Int) {
        if _health + points > Game.Health.initial {
            rbDebug("\(self.name): Health changed from \(_health) to \(Game.Health.initial)")
            _health = Game.Health.initial
        }
        else {
            rbDebug("\(self.name): Health changed from \(_health) to \(_health + points)")
            _health += points
        }
        
        if _health <= 0 {
            _health = 0
            
            rbDebug("\(self.name) is dead: health=\(_health)")
            
            runShockWave(at: _chassis!.position, scene: self.scene)
            destroy()
            
            if !_enemy {
                self.scene.loose()
            }
        }
    }
    
    // -------------------------------------------------------------------------
    
    func changeScore(by points: Int) {
        rbDebug("\(self.name): Score changed from \(_score) to \(_score + points)")
        _score += points
    }
    
    // -------------------------------------------------------------------------
    
    func changeRockets(by rockets: Int) {
        rbDebug("\(self.name): # of Rockets changed from \(_rockets) to \(_rockets + rockets)")
        _rockets += rockets
    }
    
    // -------------------------------------------------------------------------
    
    func changeBullets(by bullets: Int) {
        rbDebug("\(self.name): # of Bullets changed from \(_bullets) to \(_bullets + bullets)")
        _bullets += bullets
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Fire
    
    func fireBullet() {
        if self.state == .none {
            return
        }

        setTurrentForFire()
        
        if self.bullets <= 0 {
            rbDebug("\(self.name): No bullets anymore")

            GameSound.emptyWeapon(self.scene.world)

            return
        }

        var position = self.position
        position.x += _chassis!.size.width / 2 + 20
        position.y += 10
        
        let bullet = Bullet(addTo: self.scene, position: position)
        self.scene.addGameElement(bullet)
        bullet.start()
        
        runShockWave(at: position, scene: self.scene)
        
        self.scene.changeBullets(by: -1)
        self.scene.changeHealth(by: Game.Health.shootABullet)
    }
    
    // -------------------------------------------------------------------------
    
    func fireRocket() {
        if self.state == .none {
            return
        }

        if self.rockets <= 0 {
            rbDebug("\(self.name): No rockets anymore")

            GameSound.emptyWeapon(self.scene.world)

            return
        }

        rbDebug("\(self.name) fire rocket")

        var position = self.position
        position.y += 30
        
        let rocket = Rocket(addTo: self.scene, position: position)
        self.scene.addGameElement(rocket)
        rocket.start()
        
        self.scene.shake()
        
        self.scene.changeRockets(by: -1)
        self.scene.changeHealth(by: Game.Health.shootARocket)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Actions
    
    func hit() {
        rbDebug("\(self.name) get hit")

        if self.state == .moving {
            self.stop()
            self.scene.shake()
        }
        else if self.state == .stopped {
            self.scene.changeHealth(by: Game.Health.destroyTank)
            self.scene.changeBullets(by: Game.Weapon.bulletsForTank)
            self.scene.changeScore(by: Game.Score.destroyTank)

            self.destroy()
        }
    }

    // -------------------------------------------------------------------------
      
    func destroy() {
        if self.isDead {
            return
        }
        
        self.scene.shake()
        
        if _enemy {
            self.state = .willDie
        }
        else {
            self.state = .willDie
        }

        rbDebug("\(self.name) will die")
    }

    // -------------------------------------------------------------------------

    private func makeWreck() {
        for child in _vehicle!.children {
            child.physicsBody = nil
        }
        
        let rightAction = SKAction.rotate(byAngle: CGFloat(100.0).toRadians(), duration: 0.4)
        _turret?.run(rightAction)

        let angle = RBRandom.cgFloat(100, 200)
        let leftAction = SKAction.rotate(byAngle: -angle.toRadians(), duration: 0.4)
        let moveAction = SKAction.moveBy(x: 0, y: -40, duration: 0.4)
        _chassis?.run(SKAction.group([leftAction, moveAction]))

        self.scene.shake(_chassis!)
        
        rbDebug("\(self.name) destroyed")
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Turret function
    
    func setTurrentPosition(_ position: TurretAngle) {
        var angle: CGFloat = 0

        if position == .up {
            angle = 45.0
        }
        else if position == .middle {
            angle = 30.0
        }
        
        _turret!.removeAllActions()
        let action = SKAction.rotate(toAngle: angle.toRadians(), duration: 1.0)
        _turret!.run(action)
    }

    // -------------------------------------------------------------------------
    
    func setTurrentForFire() {
        _turret!.removeAllActions()
        let action1 = SKAction.rotate(toAngle: CGFloat(10.0).toRadians(), duration: 0.2)
        let action2 = SKAction.rotate(toAngle: CGFloat(0.0).toRadians(), duration: 0.2)
        _turret!.run(SKAction.sequence([action1, action2]))
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Move methods
    
    func startLeft() {
        _velocity = -150
        _chassis!.physicsBody?.pinned = false
        self.direction = .left
        
        setTurrentPosition(.down)
        
        self.state = .moving

        rbDebug("\(self.name) start with: \(_velocity)")
    }
    
    // -------------------------------------------------------------------------
    
    func startRight() {
        _velocity = 150
        _chassis!.physicsBody?.pinned = false
        self.direction = .right
        
        setTurrentPosition(.down)
        
        self.state = .moving

        rbDebug("\(self.name) start with: \(_velocity)")
    }

    // -------------------------------------------------------------------------

    func reverseDirection() {
        _velocity = -1 * _velocity
        
        if self.direction == .left {
            self.direction = .right
        }
        else if self.direction == .right {
            self.direction = .left
        }

        rbDebug("\(self.name) reverse direction")
    }

    // -------------------------------------------------------------------------

    func makeFaster() {
        _velocity = 180
        if _enemy {
            _velocity = -180
        }
        
        rbDebug("\(self.name) get faster: \(_velocity)")
    }

    // -------------------------------------------------------------------------

    func makeSlower() {
        _velocity = 120
        if _enemy {
            _velocity = -120
        }

        rbDebug("\(self.name) get slower: \(_velocity)")
    }

    // -------------------------------------------------------------------------

    func waitFor(time: TimeInterval) {
        if self.state != .moving {
            return
        }

        rbDebug("\(self.name) wait for \(time)s")

        self.pause()
        Repeat.once(after: time, {
            if self.state == .paused {
                rbDebug("\(self.name) restart after \(time)s")

                self.start()
            }
        })
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Game element overrides
    
    override func start() {
        _velocity = 150
        _chassis!.physicsBody?.pinned = false
        self.direction = .right
        
        if _enemy {
            self.direction = .left
            _velocity = -120
        }
        
        setTurrentPosition(.down)

        self.state = .moving

        rbDebug("\(self.name) start")
    }
    
    // -------------------------------------------------------------------------
    
    override func stop() {
        _velocity = 0
        _chassis!.physicsBody?.pinned = true
        
        setTurrentPosition(.middle)
        
        self.state = .stopped
        
        rbDebug("\(self.name) stop")
    }
    
    // -------------------------------------------------------------------------
    
    override func pause() {
        _velocity = 0
        _chassis!.physicsBody?.pinned = true
        
        setTurrentPosition(.middle)
        
        self.state = .paused
        
        rbDebug("\(self.name) paused")
    }
    
    // -------------------------------------------------------------------------
    
    override func kill() {
        _vehicle!.isHidden = true
        _vehicle?.removeAllChildren()
        _vehicle?.removeFromParent()
        _turret?.removeAllActions()
        
        _vehicle = nil
        _chassis = nil
        _turret = nil
        
        self.state = .unused

        rbDebug("\(self.name) kill (set unused)")
    }
 
    // -------------------------------------------------------------------------

    override func update() {
        if self.state == .moving {
            if _chassis?.physicsBody == nil {
                rbError("chassis.physicsBody is nil")
                return
            }
            
            let rate: CGFloat = 1.0
            let relativeVelocity: CGVector = CGVector(dx: _velocity-_chassis!.physicsBody!.velocity.dx, dy: 0)
            _chassis!.physicsBody?.velocity = CGVector(dx: _chassis!.physicsBody!.velocity.dx+relativeVelocity.dx*rate, dy: 0)
        }
        else if self.state == .willDie {
            makeWreck()
            self.state = .dead
        }
    }
    
    // -------------------------------------------------------------------------
    
    override func collide(with element: GameElement, point: CGPoint) {
        if self.isDead {
            return
        }

        rbDebug("\(self.name) collides with \(element.name)")
 
        // Check with what collision was
        if let otherTank = element as? Tank {
            if otherTank.isEnemy && !self.isEnemy {
                if otherTank.isDead {
                    return
                }
                
                // Player hits tank
                runShockWave(at: point, scene: self.scene)

                self.scene.changeHealth(by: Game.Health.hitByTank)
                
                GameSound.explosion(self.scene.world)
                
                if _health > 0 {
                    otherTank.destroy()
                }
            }
            else if otherTank.isEnemy && self.isEnemy {
                if otherTank.isDead {
                    return
                }

                // 2 enemy tanks collide, make left faster, right stop for x seconds
                if self.position.x < otherTank.position.x {
                    self.makeFaster()
                    otherTank.waitFor(time: waitTimeAfterCollide)
                }
                else {
                    self.waitFor(time: waitTimeAfterCollide)
                    otherTank.makeFaster()
                }
            }
        }
        else if let _ = element as? Sensor {
            if _enemy {
                self.reverseDirection()
            }
            else {
                self.stop()
            }
        }
    }
    
    // -------------------------------------------------------------------------
    
    override func run(_ action: SKAction) {
        _vehicle!.run(action)
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(addTo scene: GameScene, position: CGPoint, enemy: Bool = false) {
        super.init(scene: scene)
        
        _enemy = enemy
        
        self.name = "Player"
        var category: UInt32 = GameElementCategory.player.rawValue
        var contact: UInt32 = GameElementCategory.enemy.rawValue | GameElementCategory.sensor.rawValue
        var collision: UInt32 = GameElementCategory.enemy.rawValue | GameElementCategory.terrain.rawValue
        
        if _enemy {
            self.name = "Tank"
            category = GameElementCategory.enemy.rawValue
            contact = GameElementCategory.player.rawValue | GameElementCategory.enemy.rawValue | GameElementCategory.sensor.rawValue
            collision = GameElementCategory.player.rawValue | GameElementCategory.terrain.rawValue
        }
        
        _vehicle = SKNode()
        _vehicle!.position = CGPoint.zero
        scene.world.addChild(_vehicle!)
        
        // Create chassis
        _chassis = SpriteElement.init(color: debugColor, size: chassisSize)
        _chassis!.element = self
        _chassis!.position = position
        _chassis!.physicsBody =  SKPhysicsBody.init(rectangleOf: _chassis!.size)
        _chassis!.physicsBody?.affectedByGravity = true
        _chassis!.physicsBody?.categoryBitMask = category
        _chassis!.physicsBody?.contactTestBitMask = contact
        _chassis!.physicsBody?.collisionBitMask = collision
        _chassis!.name = "Tank"
        _vehicle!.addChild(_chassis!)
        
        _chassis!.lightingBitMask = 1
        _chassis!.shadowedBitMask = 1
        
        // Top
        if _enemy {
            let top = SKSpriteNode(imageNamed: "chassis-enemy")
            top.position = CGPoint(x: 0, y: -10)
            top.zPosition = 10
            top.xScale *= -1
            _chassis!.addChild(top)
            
            // Turret
            _turret = SKSpriteNode(imageNamed: "turret")
            _turret!.anchorPoint = CGPoint.zero
            _turret!.position = CGPoint(x: 0, y: 5)
            _turret!.xScale *= -1
            _turret!.zPosition = -9
            _chassis!.addChild(_turret!)
        }
        else  {
            let top = SKSpriteNode(imageNamed: "chassis")
            top.position = CGPoint(x: 0, y: -10)
            top.zPosition = 10
            _chassis!.addChild(top)
           
            // Turret
            _turret = SKSpriteNode(imageNamed: "turret")
            _turret!.anchorPoint = CGPoint.zero
            _turret!.position = CGPoint(x: 0, y: 5)
            _turret!.zPosition = 9
            _chassis!.addChild(_turret!)
        }
        
        // Left wheel
        _leftWheel = SpriteElement(imageNamed: "wheel")
        _leftWheel!.element = self
        _leftWheel!.name = "Tank-LeftWheel"
        _leftWheel!.position = CGPoint(x: _chassis!.position.x - _chassis!.size.width / 2, y: _chassis!.position.y - wheelOffsetY)
        _leftWheel!.physicsBody = SKPhysicsBody(circleOfRadius: _leftWheel!.size.width/2-2)
        _leftWheel!.physicsBody!.allowsRotation = true
        _leftWheel!.physicsBody!.density = 10.0
        _leftWheel!.physicsBody?.categoryBitMask = category
        _leftWheel!.physicsBody?.contactTestBitMask = contact
        _leftWheel!.physicsBody?.collisionBitMask = collision
        _vehicle!.addChild(_leftWheel!)
        
        // Middle wheel
        _middleWheel = SpriteElement(imageNamed: "wheel")
        _middleWheel!.element = self
        _middleWheel!.name = "Tank-MiddleWheel"
        _middleWheel!.position = CGPoint(x: _chassis!.position.x, y: _chassis!.position.y - wheelOffsetY)
        _middleWheel!.physicsBody = SKPhysicsBody(circleOfRadius: _middleWheel!.size.width/2-2)
        _middleWheel!.physicsBody!.allowsRotation = true
        _middleWheel!.physicsBody!.density = 10.0
        _middleWheel!.physicsBody?.categoryBitMask = category
        _middleWheel!.physicsBody?.contactTestBitMask = contact
        _middleWheel!.physicsBody?.collisionBitMask = collision
        _vehicle!.addChild(_middleWheel!)
        
        // Right wheel
        _rightWheel = SpriteElement(imageNamed: "wheel")
        _rightWheel!.element = self
        _rightWheel!.name = "Tank-RightWheel"
        _rightWheel!.position = CGPoint(x: _chassis!.position.x + _chassis!.size.width / 2, y: _chassis!.position.y - wheelOffsetY)
        _rightWheel!.physicsBody = SKPhysicsBody(circleOfRadius: _rightWheel!.size.width/2-2)
        _rightWheel!.physicsBody!.allowsRotation = true
        _rightWheel!.physicsBody!.density = 10.0
        _rightWheel!.physicsBody?.categoryBitMask = category
        _rightWheel!.physicsBody?.contactTestBitMask = contact
        _rightWheel!.physicsBody?.collisionBitMask = collision
        _vehicle!.addChild(_rightWheel!)
        
        // Left suspension
        let leftShockPost = SpriteElement(color: debugColor, size: CGSize.make(7, wheelOffsetY))
        leftShockPost.element = self
        leftShockPost.name = "Tank-LeftShock"
        leftShockPost.position = CGPoint(x: _chassis!.position.x - _chassis!.size.width / 2, y: _chassis!.position.y - leftShockPost.size.height/2)
        leftShockPost.physicsBody = SKPhysicsBody(rectangleOf: leftShockPost.size)
        leftShockPost.physicsBody?.categoryBitMask = category
        leftShockPost.physicsBody?.contactTestBitMask = contact
        leftShockPost.physicsBody?.collisionBitMask = collision
        _vehicle!.addChild(leftShockPost)
        
        let leftSlide = SKPhysicsJointSliding.joint(withBodyA: _chassis!.physicsBody!, bodyB: leftShockPost.physicsBody!, anchor:CGPoint(x:leftShockPost.position.x, y: leftShockPost.position.y), axis:CGVector(dx: 0.0, dy: 1.0))
        leftSlide.shouldEnableLimits = true
        leftSlide.lowerDistanceLimit = 10
        leftSlide.upperDistanceLimit = wheelOffsetY/2
        
        let leftSpring = SKPhysicsJointSpring.joint(withBodyA: _chassis!.physicsBody!, bodyB: _leftWheel!.physicsBody!, anchorA: CGPoint(x:_chassis!.position.x - _chassis!.size.width / 2, y: _chassis!.position.y), anchorB: _leftWheel!.position)
        leftSpring.damping = damping
        leftSpring.frequency = frequency
        
        let leftPin = SKPhysicsJointPin.joint(withBodyA: leftShockPost.physicsBody!, bodyB:_leftWheel!.physicsBody!, anchor:_leftWheel!.position)
        
        // Middle suspension
        let middleShockPost = SpriteElement(color: debugColor, size: CGSize.make(7, wheelOffsetY))
        middleShockPost.element = self
        middleShockPost.name = "Tank-MiddleShock"
        middleShockPost.position = CGPoint(x: _chassis!.position.x, y: _chassis!.position.y - middleShockPost.size.height/2)
        middleShockPost.physicsBody = SKPhysicsBody(rectangleOf: middleShockPost.size)
        middleShockPost.physicsBody?.categoryBitMask = category
        middleShockPost.physicsBody?.contactTestBitMask = contact
        middleShockPost.physicsBody?.collisionBitMask = collision
        _vehicle!.addChild(middleShockPost)
        
        let middleSlide = SKPhysicsJointSliding.joint(withBodyA: _chassis!.physicsBody!, bodyB: middleShockPost.physicsBody!, anchor:CGPoint(x:middleShockPost.position.x, y: middleShockPost.position.y), axis:CGVector(dx: 0.0, dy: 1.0))
        middleSlide.shouldEnableLimits = true
        middleSlide.lowerDistanceLimit = 10
        middleSlide.upperDistanceLimit = wheelOffsetY/2
        
        let middleSpring = SKPhysicsJointSpring.joint(withBodyA: _chassis!.physicsBody!, bodyB: _middleWheel!.physicsBody!, anchorA: CGPoint(x:_chassis!.position.x, y: _chassis!.position.y), anchorB: _middleWheel!.position)
        middleSpring.damping = damping
        middleSpring.frequency = frequency
        
        let middlePin = SKPhysicsJointPin.joint(withBodyA: middleShockPost.physicsBody!, bodyB:_middleWheel!.physicsBody!, anchor:_middleWheel!.position)
        
        // Right suspension
        let rightShockPost = SpriteElement(color: debugColor, size:CGSize.make(7, wheelOffsetY) )
        rightShockPost.element = self
        rightShockPost.name = "Tank-RightShock"
        rightShockPost.position = CGPoint(x:_chassis!.position.x + _chassis!.size.width / 2, y: _chassis!.position.y - rightShockPost.size.height/2)
        rightShockPost.physicsBody = SKPhysicsBody(rectangleOf: rightShockPost.size)
        rightShockPost.physicsBody?.categoryBitMask = category
        rightShockPost.physicsBody?.contactTestBitMask = contact
        rightShockPost.physicsBody?.collisionBitMask = collision
        _vehicle!.addChild(rightShockPost)
        
        let rightSlide = SKPhysicsJointSliding.joint(withBodyA: _chassis!.physicsBody!, bodyB: rightShockPost.physicsBody!, anchor:CGPoint(x:rightShockPost.position.x, y: rightShockPost.position.y), axis:CGVector(dx: 0.0, dy: 1.0))
        rightSlide.shouldEnableLimits = true
        rightSlide.lowerDistanceLimit = 10
        rightSlide.upperDistanceLimit = wheelOffsetY/2
        
        let rightSpring = SKPhysicsJointSpring.joint(withBodyA: _chassis!.physicsBody!, bodyB: _rightWheel!.physicsBody!, anchorA: CGPoint(x: _chassis!.position.x + _chassis!.size.width / 2, y: _chassis!.position.y), anchorB: _rightWheel!.position)
        rightSpring.damping = damping
        rightSpring.frequency = frequency
        
        let rightPin = SKPhysicsJointPin.joint(withBodyA: rightShockPost.physicsBody!, bodyB:_rightWheel!.physicsBody!, anchor:_rightWheel!.position)
        
        // Add all joints to the scene
        scene.physicsWorld.add(leftSlide)
        scene.physicsWorld.add(leftSpring)
        scene.physicsWorld.add(leftPin)
        scene.physicsWorld.add(middleSlide)
        scene.physicsWorld.add(middleSpring)
        scene.physicsWorld.add(middlePin)
        scene.physicsWorld.add(rightSlide)
        scene.physicsWorld.add(rightSpring)
        scene.physicsWorld.add(rightPin)
        
        _joints.append(leftSlide)
        
        setTurrentPosition(.up)
        
        _bullets = Game.Weapon.initialBullets
        _rockets = Game.Weapon.initialRockets
        
        activateLabel(parent: _chassis!)
   }

    // -------------------------------------------------------------------------

}
