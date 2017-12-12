//
//  GameScene.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 21/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene : SKScene, SKPhysicsContactDelegate {
    private let createEnemyAfterDelay: TimeInterval = 6.0
    
    private var _state: GameState = .none
    private var _elements = [GameElement]()

    private var _world = SKNode()
    private var _tank: Tank?
    private var _background: ParallaxBackground?
    private var _hills: Hill?
    private var _camera = SKCameraNode()
    private var _light = SKLightNode()

    private var _widthOfGame: CGFloat = 0

    private var _hud: GameHUD?
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var widthOfGame: CGFloat {
        get {
            return _widthOfGame
        }
    }
    
    // -------------------------------------------------------------------------
    
    var world: SKNode {
        get {
            return _world
        }
    }
    
    // -------------------------------------------------------------------------
    
    var isFinished: Bool {
        get {
            if _state == .loose || _state == .win {
                return true
            }
            
            return false
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Point system
    
    func changeHealth(by points: Int) {
        _tank!.changeHealth(by: points)
        
        _hud?.health = _tank!.health
    }
    
    // -------------------------------------------------------------------------
    
    func changeScore(by points: Int) {
        _tank!.changeScore(by: points)
        
        _hud?.score = _tank!.score
    }
    
    // -------------------------------------------------------------------------
    
    func changeBullets(by bullets: Int) {
        _tank!.changeBullets(by: bullets)
        
        _hud?.bullets = _tank!.bullets
    }
    
    // -------------------------------------------------------------------------
    
    func changeRockets(by rockets: Int) {
        _tank!.changeRockets(by: rockets)
        
        _hud?.rockets = _tank!.rockets
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Special effects
    
    func shake(_ node: SKNode? = nil) {
        let moveX1 = SKAction.move(by: CGVector(dx:-7, dy: 0), duration: 0.05)
        let moveX2 = SKAction.move(by: CGVector(dx:-10, dy: 0), duration: 0.05)
        let moveX3 = SKAction.move(by: CGVector(dx:7, dy: 0), duration: 0.05)
        let moveX4 = SKAction.move(by: CGVector(dx:10, dy: 0), duration: 0.05)
        
        let moveY1 = SKAction.move(by: CGVector(dx:0, dy: -7), duration: 0.05)
        let moveY2 = SKAction.move(by: CGVector(dx:0, dy: -10), duration: 0.05)
        let moveY3 = SKAction.move(by: CGVector(dx:0, dy: 7), duration: 0.05)
        let moveY4 = SKAction.move(by: CGVector(dx:0, dy: 10), duration: 0.05)
        
        let trembleX = SKAction.sequence([moveX1, moveX4, moveX2, moveX3])
        let trembleY = SKAction.sequence([moveY1, moveY4, moveY2, moveY3])
        
        if node == nil {
            for element in _elements {
                element.run(trembleX)
                element.run(trembleY)
            }
        }
        else {
            node!.run(trembleX)
            node!.run(trembleY)
        }
    }
    
    // -------------------------------------------------------------------------
    
    func flash() {
        let action1 = SKAction.run({
            self._light.ambientColor = UIColor.red
            self._light.lightColor = UIColor.white
        })
        let action2 = SKAction.run({
            self._light.ambientColor = UIColor.darkGray
            self._light.lightColor = UIColor.darkGray
            self._light.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        })
        let wait = SKAction.wait(forDuration: 0.05)
        
        let sequence = SKAction.sequence([action1, wait, action2, wait, action1, wait, action1, wait, action2])
        _light.run(sequence)
    }

    // -------------------------------------------------------------------------
    // MARK: - Game logic actions
    
    private func start() {
        for element in _elements {
            element.start()
        }
        
        changeHealth(by: Game.Health.initial)
       
        Repeat.once(after: createEnemyAfterDelay, {
            self.spawnEnemyTank(x: self.widthOfGame-self.frame.size.width-100)
        })

        _state = .run
    }
    
    // -------------------------------------------------------------------------
    
    private func stop() {
        for element in _elements {
            element.stop()
        }
    }
    
    // -------------------------------------------------------------------------
    
    func loose() {
        _state = .loose
        
        Repeat.once(after: 1.0, {
            self.stop()
            self._hud!.gameOver()
 
            self._light.ambientColor = UIColor.black
            self._light.lightColor = UIColor.darkGray
        })
    }
    
    // -------------------------------------------------------------------------
    
    func win() {
        _state = .win
        
        Repeat.once(after: 1.0, {
            self.stop()
            self._hud!.gameWin()
            
            self._light.ambientColor = UIColor.black
            self._light.lightColor = UIColor.darkGray
            
            self._hud!.sumUp(bulletPoints: self._tank!.bullets*Game.Score.remainingBullet, rocketPoints: self._tank!.rockets*Game.Score.remainingRocket)
        })
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Add a game element
    
    func addGameElement(_ element: GameElement) {
        _elements.append(element)
    }

    // -------------------------------------------------------------------------

    func addEnemyTank(x: CGFloat) -> GameElement {
        let enemy = Tank(addTo: self, position: CGPoint(x: x, y: 600), enemy: true)
        addGameElement(enemy)
        
        return enemy
    }

    // -------------------------------------------------------------------------

    func spawnEnemyTank(x: CGFloat) {
        rbDebug("Create spawned tank after \(createEnemyAfterDelay) at \(x)")
        
        let tank = addEnemyTank(x: x)
        tank.start()
        
        Repeat.once(after: createEnemyAfterDelay, {
            self.spawnEnemyTank(x: x)
        })
    }
    
    // -------------------------------------------------------------------------
    // MARK: - User input

    func handleGameKey(_ key: GameKey) {
        rbDebug("Handle game key: \(key)")
        
        if _state == .none {
            self.start()
            return
        }

        if _state != .run {
            return
        }

        if key == .left {
            if _tank!.state == .moving {
                if _tank?.direction == .right {
                    _tank?.stop()
                }
            }
            else {
                _tank?.startLeft()
            }
        }
        else if key == .right {
            if _tank!.state == .moving {
                if _tank?.direction == .left {
                    _tank?.stop()
                }
            }
            else {
                _tank?.startRight()
            }
        }
        else if key == .up {
            _tank?.fireBullet()
        }
        else if key == .down {
            if _tank!.state == .stopped {
                _tank!.fireRocket()
            }
        }
        else if key == .fire {
            if _state == .none {
                self.start()
            }
            else if _state == .run {
                _tank?.fireBullet()
            }
            else if _state == .paused {
                self.start()
            }
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Game loop
    
    override func didFinishUpdate() {        
        _camera.position.x = _tank!.position.x + self.frame.midX - 60

        #if os(iOS)
        
        _camera.position.y = _tank!.position.y + self.frame.midY - 100
        _light.position = CGPoint(x: _tank!.position.x+self.frame.midX, y: self.frame.midY+200)
        
        #else

        _camera.position.y = _tank!.position.y + self.frame.midY - 200
        _light.position = CGPoint(x: _tank!.position.x+self.frame.midX, y: self.frame.midY)

        #endif
        

        for element in _elements {
            element.update()
        }
    
        var tankCount = 0
        
        // Search for dead objects and remove them
        var index = _elements.count-1
        while index >= 0 {
            let element = _elements[index]
            if element.state == .unused {
                _elements.remove(at: index)
                element.kill()
            }
            else {
                if let tank = element as? Tank {
                    if tank.isEnemy && !tank.isDead {
                        tankCount += 1
                    }
                }
            }
            
            index -= 1
        }

        if _state != .run {
            return
        }
        
        if tankCount == 0 {
            rbDebug("All enemies killed, win")
            self.win()
            
            return
        }

        if _tank?.bullets == 0 && _tank?.rockets == 0 {
            rbDebug("No weapons anymore, loose")
            self.loose()
            
            return
        }
    }

    // -------------------------------------------------------------------------

    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node as? GameElementNode
        let nodeB = contact.bodyB.node as? GameElementNode

        if nodeA != nil && nodeB != nil {
            let elementA = nodeA!.element!
            let elementB = nodeB!.element!
            
            elementA.collide(with: elementB, point: contact.contactPoint)
            elementB.collide(with: elementA, point: contact.contactPoint)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    private func initLight() {
        _light.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        _light.falloff = 0.5
        _light.ambientColor = UIColor.darkGray
        _light.lightColor = UIColor.darkGray
        _light.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        

        _light.categoryBitMask = 1
        self.addChild(_light)
        
        _light.isEnabled = true
    }

    // -------------------------------------------------------------------------

    override func didMove(to view: SKView) {
        self.addChild(_world)
        
        _background = ParallaxBackground(addTo: self, imageLayer1Named: "background1", imageLayer2Named: "background3", imageLayer3Named: "background2")
        addGameElement(_background!)
        
        // Rain particle emitter
        let path = Bundle.main.path(forResource: "Rain_Emitter", ofType: "sks")
        let rainParticle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as? SKEmitterNode
        rainParticle?.position = CGPoint(x: self.frame.width/2, y: self.frame.height)
        rainParticle?.name = "rainParticle"
        rainParticle?.targetNode = _world
        rainParticle?.particleBirthRate = 300.0
        rainParticle?.zPosition = -100
        
        let hills = Hill(addTo: self)
        hills.position = CGPoint(x: 0, y: 0)
        hills.minHillKeyPoints = 50
        hills.begin = 500
        hills.end = 2000
        hills.minDX = 250
        hills.textureImage = UIImage(named: "terrain")
        hills.start()
        
        // Save hill width as game width
        _widthOfGame = hills.width
        
        _tank = Tank(addTo: self, position: CGPoint(x: 100, y: 400))
        addGameElement(_tank!)
        
        let tankCount: Int = Int(_widthOfGame/100.0) - 1
        for i in 1...tankCount {
            let _ = addEnemyTank(x:CGFloat(i*1000))
        }
        rbDebug("\(tankCount) tanks created")
        
        // Add begin and end sensor
        let _ = Sensor(addTo: self, position: CGPoint(x: 0, y: 200), height: 400)
        let _ = Sensor(addTo: self, position: CGPoint(x: _widthOfGame-self.frame.size.width-50, y: 200), height: 400)
        
        self.camera = _camera
        self.addChild(_camera)
        _camera.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        _camera.addChild(rainParticle!)
        
        initLight()
        
        // HUD
        _hud = GameHUD(addTo: self)
        _hud?.reset(score: 0, health: Game.Health.initial, bullets: Game.Weapon.initialBullets, rockets: Game.Weapon.initialRockets)

        self.physicsWorld.contactDelegate = self
    }

    // -------------------------------------------------------------------------

    override init(size: CGSize) {
        super.init(size: size)

    }

    // -------------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // -------------------------------------------------------------------------

}
