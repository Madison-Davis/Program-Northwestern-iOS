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
    var character = SKShapeNode()
    
    override func didMove(to view: SKView) {
        createBackground()
        makeBaseBrick()
        makeCharacter()
        character.physicsBody?.isDynamic = true
        character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))
    }

    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        let starsBackground = SKSpriteNode(texture: stars)
        starsBackground.size = CGSize(width: 414.0, height: 896.0)
        starsBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        starsBackground.zPosition = -1
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
    
    func makeCharacter() {
        character = SKShapeNode(circleOfRadius: 10)
        character.position = CGPoint(x: frame.midX, y: frame.minY + 200)
        character.strokeColor = UIColor.black
        character.fillColor = UIColor.yellow
        character.name = "character"
        
        // physics shape matches ball image
        character.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // ignores all forces and impulses
        character.physicsBody?.isDynamic = false
        // use precise collision detection
        character.physicsBody?.usesPreciseCollisionDetection = true
        // no loss of energy from friction
        character.physicsBody?.friction = 0
        // gravity is not a factor
        character.physicsBody?.affectedByGravity = true
        // bounces fully off of other objects
        character.physicsBody?.restitution = 1
        // does not slow down over time
        character.physicsBody?.linearDamping = 0
        character.physicsBody?.contactTestBitMask = (character.physicsBody?.collisionBitMask)!
        addChild(character) // add ball object to the view
    }
}
