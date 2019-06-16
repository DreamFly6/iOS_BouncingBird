//
//  Spike.swift
//  BouncingBird
//
//  Created by Robert Dudziński on 13/06/2019.
//  Copyright © 2019 Robert. All rights reserved.
//

import SpriteKit
import GameplayKit

class Spike : GameObject
{
    public static let length : CGFloat = 200;
    
    private let side : Bool;
    private let colorManager : LevelColorManager;
    
    private var triangle : SKShapeNode = SKShapeNode()
    
    private static var didInitPoints : Bool = false;
    private static var path : UIBezierPath = UIBezierPath();
    
    init(_ scene : SKScene,_ side : Bool, _ colorManager : LevelColorManager)
    {
        self.side = side;
        self.colorManager = colorManager;
        super.init(scene);
        
        if !Spike.didInitPoints
        {
            Spike.initPoints();
        }
        
        zPosition = -100;
        triangle = SKShapeNode(path: Spike.path.cgPath)
        triangle.fillColor = colorManager.getCurColor();
        addChild(triangle);
        
        if side
        {
            triangle.position.x = -scene.frame.size.width / 2 + 15;
        }
        else
        {
            triangle.position.x = scene.frame.size.width / 2 - 15;
        }
        
        var startPos = triangle.position;
        let endPos = triangle.position;
        
        if side
        {
            startPos.x -= 150;
        }
        else
        {
            startPos.x += 150;
        }
        
        triangle.position = startPos;
        triangle.run(SKAction.move(to: endPos, duration: 0.5))
    }
    
    required init(coder nsCoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func initPoints()
    {
        didInitPoints = true;
        
        path.move(to: CGPoint(x: 0.0, y: 50.0))
        path.addLine(to: CGPoint(x: 60.0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: -50.0))
        path.addLine(to: CGPoint(x: -60, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 50))
    }
    
    public func hide()
    {
        var endPos = triangle.position;
        
        if side
        {
            endPos.x -= 150;
        }
        else
        {
            endPos.x += 150;
        }
        
        triangle.run(SKAction.move(to: endPos, duration: 0.5))
        run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]))
    }
    
    public func enablePhycisc()
    {        
        triangle.physicsBody = SKPhysicsBody(polygonFrom: Spike.path.cgPath)
        triangle.physicsBody?.affectedByGravity = false;
        triangle.physicsBody?.categoryBitMask = GameScene.maskSpike;
        triangle.physicsBody?.contactTestBitMask = GameScene.maskEverything;
        triangle.physicsBody?.collisionBitMask = 0;
        
        triangle.run(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 2));
    }
    
    public func runActionOnTriangle(_ action : SKAction)
    {
        triangle.run(action);
    }
}
