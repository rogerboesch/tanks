//
//  Hill.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 24/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import SpriteKit

class Hill : GameElement {
    private static let kHillSegmentWidth: CGFloat = 10
    
    private var _minHillKeyPoints: Int = 100
    private var _points = Array<CGPoint>()
    
    private var _paddingTop: CGFloat = 20
    private var _paddingBottom: CGFloat = 20
    private var _minDX: CGFloat = 160
    private var _minDY: CGFloat = 60
    private var _rangeDX: CGFloat = 80
    private var _rangeDY: CGFloat = 40
    private var _begin: CGFloat = 0
    private var _end: CGFloat = 0
    private var _width: CGFloat = 0
    
    private var _lineNode: SKShapeNode?
    private var _node: ShapeElement?
    private var _image: UIImage?
    private var _lineColor = UIColor.clear
    private var _lineWidth: CGFloat = 1.0
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var position: CGPoint {
        get {
            return _node!.position
        }
        set(value) {
            _node!.position = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var width: CGFloat {
        get {
            return _width
        }
    }
    
    // -------------------------------------------------------------------------

    var lineNode: SKShapeNode {
        get {
            if _lineNode == nil {
                _lineNode = SKShapeNode()
            }

            generateLineNode()
            
            return _lineNode!
        }
    }
    
    // -------------------------------------------------------------------------
   
    var textureImage: UIImage? {
        get {
            return _image
        }
        set(value) {
            _image = value
            
            applyTexture()
        }
    }
    
    // -------------------------------------------------------------------------
    
    var minHillKeyPoints: Int {
        get {
            return _minHillKeyPoints
        }
        set(value) {
            if value > 2 {
                _points.removeAll()
                _minHillKeyPoints = value
            }
            else {
                // TDOO: Warning
            }
        }
    }
    
    // -------------------------------------------------------------------------
    
    var begin: CGFloat {
        get {
            return _begin
        }
        set(value) {
            _points.removeAll()
            _begin = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var end: CGFloat {
        get {
            return _end
        }
        set(value) {
            _points.removeAll()
            _end = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var paddingTop: CGFloat {
        get {
            return _paddingTop
        }
        set(value) {
            _points.removeAll()
            _paddingTop = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var paddingBottom: CGFloat {
        get {
            return _paddingBottom
        }
        set(value) {
            _points.removeAll()
            _paddingBottom = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var minDX: CGFloat {
        get {
            return _minDX
        }
        set(value) {
            _points.removeAll()
            _minDX = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var minDY: CGFloat {
        get {
            return _minDY
        }
        set(value) {
            _points.removeAll()
            _minDY = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var rangeDX: CGFloat {
        get {
            return _rangeDX
        }
        set(value) {
            _points.removeAll()
            _rangeDX = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var rangeDY: CGFloat {
        get {
            return _rangeDY
        }
        set(value) {
            _points.removeAll()
            _rangeDY = value
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Game element overrides

    override func start() {
        generateCurvyNode()
    }

    // -------------------------------------------------------------------------
    // MARK: - Helper functions
   
    private func applyTexture() {
        if _node == nil {
            return
        }
        
        if _image == nil {
            _node?.fillTexture = nil
            return
        }

        #if os(iOS)

        // Just for demo purpose, make in real game more accurate
        let targetSize = _image!.size // CGSize.make(10, 200)
        
        UIGraphicsBeginImageContext(targetSize)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(_image!.cgImage!, in: CGRect.make(0, 0, targetSize.width, targetSize.height), byTiling: true)
        let texture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        _node!.fillTexture = SKTexture(image: texture!)
        
        #else

        _node!.fillTexture = SKTexture(image: _image!)

        #endif
    }

    // -------------------------------------------------------------------------

    private func generatePoints() {
        _points.removeAll()
        
        let winSize: CGSize = self.scene.size
        
        var x: CGFloat = CGFloat(-_minDX)
        var y: CGFloat = winSize.height/2
        var dy: CGFloat = 0
        var ny: CGFloat = 0
        var sign: CGFloat = 1 // +1 - going up, -1 - going  down

        let height: CGFloat = 400
        
        for i in 0..._minHillKeyPoints-1 {
            _points.append(CGPoint(x:x, y:y))
            
            if i == 0 {
                x = 0
                y = height / 2
            }
            else if i == 1 && _begin > 0 {
                x += _begin
            }
            else {
                x += RBRandom.cgFloat(0, _rangeDX) + _minDX
                
                while(true) {
                    dy = RBRandom.cgFloat(0, _rangeDY) + _minDY
                    ny = y + dy * sign
                    
                    if ny < height-_paddingTop && ny > _paddingBottom {
                        break
                    }
                }
                
                y = ny
            }
            
            sign *= -1
        }
        
        // Last point
        x += RBRandom.cgFloat(0, _rangeDX) + _minDX
        _points.append(CGPoint(x:x, y:CGFloat(_minDY)+_paddingBottom))
        
        if _end > 0 {
            x += _end
            _points.append(CGPoint(x:x, y:CGFloat(_minDY)+_paddingBottom))
        }
        
        _width = x
    }
    
    // -------------------------------------------------------------------------
    
    private func generateLineNode() {
        if _points.count == 0 {
            generatePoints()
        }
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: _points[0].x, y: 0))
        
        var lastX: CGFloat = 0
        
        for i in 1..._points.count-1 {
            let p = _points[i]

            path.addLine(to: p)
            
            lastX = p.x
        }
        
        path.addLine(to: CGPoint(x: lastX, y: 0))
        
        _lineNode!.path = path
        _lineNode!.strokeColor = UIColor.red
        _lineNode!.fillColor = UIColor.clear
        _lineNode!.lineWidth = 2
    }
    
    // -------------------------------------------------------------------------
    
    private func generateCurvyNode() {
        if _points.count == 0 {
            generatePoints()
        }
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: _points[0].x, y: 0))
        
        var lastX: CGFloat = 0
        
        for i in 1..._points.count-1 {
            let p0 = _points[i-1]
            let p1 = _points[i]
            let hSegments = floorf(Float(p1.x-p0.x)/Float(Hill.kHillSegmentWidth))
            
            let dx = Float(p1.x - p0.x) / hSegments
            let da = Float(Double.pi) / hSegments
            let ymid = (p0.y + p1.y) / 2
            let ampl = (p0.y - p1.y) / 2
            
            var pt0 = CGPoint.zero
            var pt1 = CGPoint.zero
            pt0 = p0
            
            for j in 0...Int(hSegments+1) {
                pt1.x = p0.x + CGFloat(Float(j) * dx)
                pt1.y = ymid + ampl * CGFloat(cosf(da * Float(j)))
                
                path.addLine(to: pt0)
                path.addLine(to: pt1)
                
                pt0 = pt1
                
                lastX = pt1.x
            }
        }
        
        path.addLine(to: CGPoint(x: lastX, y: 0))
        
        _node!.path = path
        _node!.strokeColor = _lineColor
        _node!.fillColor = UIColor.white
        _node!.lineWidth = _lineWidth
        
        _node!.physicsBody = SKPhysicsBody(edgeChainFrom: path)
        _node!.physicsBody?.isDynamic = false
        _node!.physicsBody!.categoryBitMask = GameElementCategory.terrain.rawValue
        _node!.physicsBody!.contactTestBitMask = GameElementCategory.weapon.rawValue
        
        applyTexture()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init(addTo scene: GameScene) {
        super.init(scene: scene)

        self.name = "Hills"

        _node = ShapeElement()
        _node!.element = self
        _node!.name = "Hills"

        generateCurvyNode()
        scene.world.addChild(_node!)
    }
    
    // -------------------------------------------------------------------------
}
