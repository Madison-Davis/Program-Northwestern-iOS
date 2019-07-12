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

class SceneTwo: SKScene {
    
    override func didMove(to view: SKView) {
        createBackground()
    }
    
    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        let starsBackground = SKSpriteNode(texture: stars)
        starsBackground.zPosition = -1
        starsBackground.position = CGPoint(x: 0, y: 0)
        addChild(starsBackground)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let sceneOne = GameScene(fileNamed: "GameScene")
        sceneOne?.scaleMode = .aspectFill
        self.view?.presentScene(sceneOne!, transition: SKTransition.fade(withDuration: 0.15))
    }
    
}
