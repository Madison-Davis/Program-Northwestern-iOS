//
//  SceneTwo.swift
//  Dev Team Doodle
//
//  Created by Madison Davis on 7/12/19.
//  Copyright © 2019 Madison Davis. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SceneTwo: SKScene, SKPhysicsContactDelegate {
    
    var brick = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        createBackground()
        makeBaseBrick()
    }
    
    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        let starsBackground = SKSpriteNode(texture: stars)
        starsBackground.zPosition = -1
        starsBackground.position = CGPoint(x: 0, y: 0)
        addChild(starsBackground)
    }
    
    func makeBaseBrick() {
        for i in 1...7 {
            brick = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 20))
            brick.position = CGPoint(x: 55 * (i-1) + Int(frame.minX) + 40, y: Int(frame.minY) + 150)
            brick.name = "brick"
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
            brick.physicsBody?.isDynamic = false
            addChild(brick)
        }
    }
}
