//
//  GameScene.swift
//  Dev Team Doodle
//
//  Created by Madison Davis on 7/12/19.
//  Copyright © 2019 Madison Davis. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scene: SKScene = GameScene(size: self.size)
    var transition: SKTransition = SKTransition.fadeWithDuration(1)
    
    override func didMove(to view: SKView) {
        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let sceneTwo = SceneTwo(fileNamed: "SceneTwo")
        sceneTwo?.scaleMode = .aspectFill
        self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 0.15))
    }
    
}
