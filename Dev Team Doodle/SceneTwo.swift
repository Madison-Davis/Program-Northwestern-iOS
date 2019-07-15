//
//  SceneTwo.swift
//  Dev Team Doodle
//
//  Created by Madison Davis on 7/12/19.
//  Copyright © 2019 Madison Davis. All rights reserved.
//

import Foundation
import CoreMotion
import SpriteKit
import GameplayKit

class SceneTwo: SKScene, SKPhysicsContactDelegate {
    var brick = SKSpriteNode()
    var bricks = [SKSpriteNode]()
    var character = SKShapeNode()
    var motionManager: CMMotionManager!
    var previousGravity = SKPhysicsWorld()
    var lastTouchPosition: CGPoint?
    
    override func didMove(to view: SKView) {
        createBackground()
        makeInitialBricks()
        makeCharacter()
        physicsWorld.contactDelegate = self
        character.physicsBody?.isDynamic = true
        character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -15))
    }
    
    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        let starsBackground = SKSpriteNode(texture: stars)
        starsBackground.size = CGSize(width: 414.0, height: 896.0)
        starsBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        starsBackground.zPosition = -1
        addChild(starsBackground)
    }
    
    func makeInitialBricks() {
        //base bricks
        for i in 1...7 {
            brick = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 20))
            brick.position = CGPoint(x: 55 * (i-1) + Int(frame.minX) + 40, y: Int(frame.minY) + 150)
            brick.name = "brick"
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
            brick.physicsBody?.isDynamic = false
            bricks.append(brick)
            addChild(brick)
        }
        //bricks that start the character
        for i in 1...9 {
            for _ in 1...(Int.random(in: 1...3)) {
                brick = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 20))
                brick.position = CGPoint(x: CGFloat.random(in: frame.minX...frame.maxX), y: CGFloat(frame.minX + CGFloat((80 * i))))
                brick.name = "brick"
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false
                bricks.append(brick)
                addChild(brick)
            }
        }
    }
    
    func speedManager() {
        if let characterYSpeed = character.physicsBody?.velocity.dy {
            if characterYSpeed >= CGFloat(800) {
                character.physicsBody?.velocity.dy = CGFloat(800)
            }
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
        character.physicsBody?.restitution = 0
        // does not slow down over time
        character.physicsBody?.linearDamping = 0
        character.physicsBody?.contactTestBitMask = (character.physicsBody?.collisionBitMask)!
        addChild(character) // add ball object to the view
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - character.position.x, y: currentTouch.y - character.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: previousGravity.gravity.dy)
        }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: previousGravity.gravity.dy)
        }
        #endif
        if character.position.x > frame.maxX {
            character.position.x = frame.minX
        }
        else if character.position.x < frame.minX {
            character.position.x = frame.maxX
        }
        if character.position.y < frame.minY {
            let alert = UIAlertController(title: "Game Over", message: "You lost! A ha ha.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "back", style: UIAlertAction.Style.default, handler: nil))
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        speedManager()
        if let characterYVelocity = character.physicsBody?.velocity.dy {
            if characterYVelocity > CGFloat(0) {
                for brick in bricks {
                    brick.physicsBody = nil
                }
            } else {
                for brick in bricks {
                    brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                    brick.physicsBody?.isDynamic = false
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let characterYVelocity = character.physicsBody?.velocity.dy {
            if characterYVelocity >= CGFloat(0) {
                if contact.bodyA.node?.name == "character" ||
                    contact.bodyB.node?.name == "character" {
                    character.physicsBody?.velocity.dy = CGFloat(800)
                }
            }
        }
    }
}
