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
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
        label.center = CGPoint(x: 205, y: 150)
        label.textAlignment = .center
        label.font = UIFont(name: "Marker Felt", size: 50.0)
        label.backgroundColor = UIColor.yellow
        label.textColor = UIColor.black
        label.text = "Doodle Jump"
        self.view?.addSubview(label)
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let sceneTwo = SceneTwo(fileNamed: "SceneTwo")
        sceneTwo?.scaleMode = .aspectFill
        self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 0.15))
    }
    
}
