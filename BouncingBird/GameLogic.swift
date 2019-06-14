//
//  GameLogic.swift
//  BouncingBird
//
//  Created by Robert Dudziński on 13/06/2019.
//  Copyright © 2019 Robert. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameLogic
{
    private let scene : GameScene
    
    private let player : Player;
    private var leftSpikes = [Spike]();
    private var rightSpikes = [Spike]();
    private var gameObjects = [GameObject]();
    
    private let spikesSlots : Int
    private let minSpikes : Int = 2;
    private let maxSpikes : Int;
    
    private var curScore : Int = 0;
    private var bestScore : Int = 0;
    
    public init(_ scene : GameScene)
    {
        self.scene = scene;
        
        player = Player(scene);
        gameObjects.append(player);
        
        spikesSlots = Int(scene.size.height / Spike.length)
        maxSpikes = spikesSlots - 2;
        
        bestScore = loadBestScore();
        scene.setScore(curScore);
        
        generateSpikes();
    }
    
    public func update(_ delta : CGFloat)
    {
        for go in gameObjects
        {
            go.update(delta);
        }
    }
    
    public func jump()
    {
        player.jump()
    }
    
    public func onLeftEdge()
    {
        player.onLeftEdge();
        onBounce();
    }
    
    public func onRightEdge()
    {
        player.onRightEdge();
        onBounce();
    }
    
    public func onDeath()
    {
        let newBest = curScore > bestScore
        
        player.onDeath();
        scene.onGameOver(bestScore, newBest);
        
        if newBest
        {
            saveBestScore();
        }
    }
    
    private func onBounce()
    {
        if !player.getIsAlive()
        {
            return;
        }
        curScore = curScore + 1;
        
        scene.setScore(curScore);
    }
    
    private func generateSpikes()
    {
        generateSpikes(true);
        generateSpikes(false);
    }
    
    private func generateSpikes(_ side : Bool)
    {
        var spikesArray = leftSpikes
        
        if !side
        {
            spikesArray = rightSpikes
        }
        
        for spike in spikesArray
        {
            spike.hide()
        }
        
        spikesArray.removeAll();
        
        var newSpikesCount = randSpikesNumber();
        var newSlots : [Int] = Array()
        for i in 0...spikesSlots
        {
            newSlots.append(i);
        }
        
        for _ in 0...newSpikesCount
        {
            newSlots.remove(at: randomInt(newSlots.count));
        }
        
        for slotIndex in newSlots
        {
            var spike = Spike(scene, side);
            spike.position.y = Spike.length * CGFloat(slotIndex) - scene.frame.size.height / 2;
        }
    }
    
    private func randSpikesNumber() -> Int
    {
        return randomInt(minSpikes, maxSpikes);
    }
    
    private func randomInt(_ minVal : Int, _ maxVal : Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(maxVal - minVal))) + minVal;
    }
    
    private func randomInt(_ maxVal : Int) -> Int
    {
        return randomInt(0, maxVal);
    }
    
    private func loadBestScore() -> Int
    {
        return 0;
    }
    
    private func saveBestScore()
    {
        
    }
}
