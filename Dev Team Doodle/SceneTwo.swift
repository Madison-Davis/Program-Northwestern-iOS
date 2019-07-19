//
//  SceneTwo.swift
//  Dev Team Doodle
//
//  Created by Madison Davis on 7/12/19.
//  Copyright © 2019 Madison Davis. All rights reserved.
//

var score:Int = 0

import Foundation
import CoreMotion
import SpriteKit
import GameplayKit

class SceneTwo: SKScene, SKPhysicsContactDelegate {
    var brick = SKSpriteNode()
    var movingBrick = SKSpriteNode()
    var fakeBrick = SKSpriteNode()
    var bricks = [SKSpriteNode]()
    var character = SKSpriteNode()
    var motionManager = CMMotionManager()
    var previousGravity = SKPhysicsWorld()
    var backButton = SKLabelNode()
    var lastTouchPosition: CGPoint?
    var counter = 1
    var sceneOneVariable = GameScene()
    var distance: CGFloat = 0.0
    let scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    var numberOfTimesBricksHaveMovedDown = 1.0
    var doOnce = 1
    var oneTime = 1
    var moveB = SKAction()
    let brickBitMask = UInt32(1)
    let fakeBitMask = UInt32(2)
    
    override func didMove(to view: SKView) {
        createBackground()
        makeInitialBricks()
        chooseNumber()
        makeScore()
        physicsWorld.contactDelegate = self
        character.physicsBody?.isDynamic = true
        character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -15))
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdates(to: .main) {
                (data, error) in
                guard let _ = data, error == nil else {
                    return
                }
            }
        }
    }
    
    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        let starsBackground = SKSpriteNode(texture: stars)
        starsBackground.size = CGSize(width: 414.0, height: 896.0)
        starsBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        starsBackground.zPosition = -1
        addChild(starsBackground)
    }
    
    func makeScore() {
        scoreLabel.center = CGPoint(x: 210, y: 220)
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont(name: "Marker Felt", size: 25.0)
        scoreLabel.backgroundColor = UIColor.orange
        scoreLabel.textColor = UIColor.black
        scoreLabel.text = "Score: "
        self.view?.addSubview(scoreLabel)
    }
    
    func makeBackButton() {
        backButton.text = "Game Over. Tap to Restart."
        backButton.fontSize = 20
        backButton.position = CGPoint(x: frame.midX, y: frame.midY - 200)
        addChild(backButton)
    }
    
    func makeInitialBricks() {
        //make the base bricks
        for i in 1...7 {
            brick = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 5))
            brick.position = CGPoint(x: 55 * (i-1) + Int(frame.minX) + 40, y: Int(frame.minY) + 50)
            brick.name = "brick\(counter)"
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
            brick.physicsBody?.isDynamic = false
            brick.physicsBody?.categoryBitMask = brickBitMask
            brick.physicsBody?.collisionBitMask = brickBitMask
            bricks.append(brick)
            addChild(brick)
            counter += 1
        }
        //make the random bricks
        for i in 1...9 {
            for _ in 1...(Int.random(in: 1...3)) {
                brick = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 5))
                brick.position = CGPoint(x: CGFloat.random(in: frame.minX...frame.maxX), y: CGFloat(frame.minX + CGFloat((80 * i))))
                brick.name = "brick\(counter)"
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false
                brick.physicsBody?.categoryBitMask = brickBitMask
                brick.physicsBody?.collisionBitMask = brickBitMask
                bricks.append(brick)
                addChild(brick)
                counter += 1
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
    
    func makeCharacter(image: String) {
        character = SKSpriteNode(imageNamed: image)
        character.position = CGPoint(x: frame.midX, y: frame.minY + 200)
        character.name = "character"
        // physics shape matches ball image
        character.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // ignores all forces and impulses
        character.physicsBody?.isDynamic = false
        // use precise collision detection
        character.physicsBody?.usesPreciseCollisionDetection = true
        // no loss of energy from friction
        character.physicsBody?.friction = 0
        // gravity is a factor
        character.physicsBody?.affectedByGravity = true
        // bounces fully off of other objects
        character.physicsBody?.restitution = 0
        // does not slow down over time
        character.physicsBody?.linearDamping = 0
        character.physicsBody?.contactTestBitMask = (character.physicsBody?.collisionBitMask)!
        addChild(character) // add ball object to view
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if self.atPoint(location) == self.backButton {
                switchToSceneOne()
            }
        }
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
            physicsWorld.gravity = CGVector(dx: CGFloat(accelerometerData.acceleration.x) * 20, dy: previousGravity.gravity.dy)
        }
        #endif
        if character.position.x > frame.maxX {
            character.position.x = frame.minX
        }
        else if character.position.x < frame.minX {
            character.position.x = frame.maxX
        }
        
        if character.position.y < frame.minY {
            character.removeFromParent()
            if oneTime == 1 {
                self.makeBackButton()
                oneTime = 0
            }
        }
        
        for Brick in bricks {
            if Brick.position.y < frame.minY {
                let index = bricks.firstIndex(of: Brick)!
                bricks.remove(at: index)
                Brick.removeFromParent()
                brick = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 5))
                if let y = bricks.last {
                    brick.position = CGPoint(x: CGFloat.random(in: frame.minX...frame.maxX), y: y.position.y + CGFloat(40))
                    brick.name = "brick\(counter)"
                    brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                    brick.physicsBody?.isDynamic = false
                    bricks.append(brick)
                    addChild(brick)
                    counter += 1
                    let movingBrickP = Int.random(in: 1...5)
                    let fakeBrickP = Int.random(in: 1...3)
                    if movingBrickP <= 1 {
                        let movingBrickY = bricks.last?.position.y
                        bricks.last?.removeFromParent()
                        bricks.removeLast()
                        movingBrick = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 5))
                        let direction = Bool.random()
                        if direction == true {
                            movingBrick.position = CGPoint(x: frame.minX, y: movingBrickY! + CGFloat(40))
                        }
                        else {
                            movingBrick.position = CGPoint(x: frame.maxX, y: movingBrickY! + CGFloat(40))
                        }
                        movingBrick.name = "brick\(counter)"
                        movingBrick.physicsBody = SKPhysicsBody(rectangleOf:movingBrick.size)
                        movingBrick.physicsBody?.isDynamic = true
                        movingBrick.physicsBody?.affectedByGravity = false
                        movingBrick.physicsBody?.categoryBitMask = brickBitMask
                        movingBrick.physicsBody?.collisionBitMask = brickBitMask
                        bricks.append(movingBrick)
                        addChild(movingBrick)
                        counter += 1
                    }
                    if fakeBrickP <= 1 {
                        let fakeBrickY = (bricks.last?.position.y)! + CGFloat(20)
                        fakeBrick = SKSpriteNode(color: .orange, size: CGSize(width: 50, height: 5))
                        fakeBrick.position = CGPoint(x: CGFloat.random(in: frame.minX...frame.maxX), y: fakeBrickY)
                        fakeBrick.name = "brick\(counter)"
                        fakeBrick.physicsBody?.categoryBitMask = fakeBitMask
                        bricks.append(fakeBrick)
                        addChild(fakeBrick)
                        counter += 1
                    }
                }
            }
            if Brick.color == .blue {
                if Brick.position.x <= frame.minX + 50 {
                    moveB = SKAction.moveTo(x: frame.maxX, duration: TimeInterval(Int.random(in: 2...6)))
                    Brick.run(moveB)
                }
                else if Brick.position.x >= frame.maxX - 50 {
                    moveB = SKAction.moveTo(x: frame.minX, duration: TimeInterval(Int.random(in: 2...6)))
                    Brick.run(moveB)
                }
            }
        }
        speedManager()
        if let characterYVelocity = character.physicsBody?.velocity.dy {
            if characterYVelocity > CGFloat(0) {
                for brick in bricks {
                    brick.physicsBody = nil
                }
            } else {
                for brick in bricks {
                    if brick.color != .orange {
                        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                    }
                    brick.physicsBody?.isDynamic = false
                }
            }
        }
        
        if character.position.y > frame.midY {
            distance = character.position.y - frame.midY
            character.position.y = frame.midY
            //make a timer so that the bricks slowly go down, but do it later
            //move down all the bricks
            for brick in bricks {
                let initialYPosition = brick.position.y
                brick.position.y = initialYPosition - distance
            }
            //record # times bricks moved down
            if doOnce == 1 {
                numberOfTimesBricksHaveMovedDown = numberOfTimesBricksHaveMovedDown + 0.1
                doOnce = 0
            }
            score = Int(numberOfTimesBricksHaveMovedDown * 40)
            for _ in 1...2 {
                scoreLabel.text = "Score: " + String(score)
            }
        }
        doOnce = 1
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
    
    func switchToSceneOne() {
        let sceneOne = GameScene()
        sceneOne.scaleMode = .resizeFill
        self.view?.presentScene(sceneOne, transition: SKTransition.fade(withDuration: 0.15))
        sceneOneVariable.playButton.alpha = 1
        sceneOneVariable.highScoreLabel.alpha = 1
        sceneOneVariable.numberOfTimesReset = 1
    }
    
    func chooseNumber() {
        let ball = Int.random(in: 1...5)
        if ball == 1 {
            makeCharacter(image: "astro")
        }
        if ball == 2 {
            makeCharacter(image: "moon")
        }
        if ball == 3 {
            makeCharacter(image: "star")
        }
        if ball == 4 {
            makeCharacter(image: "purple")
        }
        if ball == 5 {
            makeCharacter(image: "rocket")
        }
    }
}


