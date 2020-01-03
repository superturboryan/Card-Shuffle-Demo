//
//  CoinExplosionScene.swift
//  Card-Shuffle-Animation
//
//  Created by Ryan David Forsyth on 2019-12-27.
//  Copyright © 2019 Ryan David Forsyth. All rights reserved.
//

import UIKit
import SpriteKit

class CoinExplosionScene: SKScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.physicsBody = .init(edgeLoopFrom: self.frame)
        
        self.scene?.backgroundColor = .clear
    }
    
    func setupEmittersWithPosition(_ position:CGPoint) {
        
        let coinEmitter = SKEmitterNode(fileNamed: "Coin-Explosion.sks")
        
        let glowEmitter = SKEmitterNode(fileNamed: "Glow.sks")
        
        coinEmitter?.position = position
        
        glowEmitter?.position = position
        
        coinEmitter?.particleColor = .clear
        
        coinEmitter?.particleColorSequence = nil
        
        coinEmitter?.particleColorBlendFactor = 0
        
        self.addChild(coinEmitter!)
        self.addChild(glowEmitter!)
    }
    
}

