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
let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
let playButton = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
let highScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
    
    override func didMove(to view: SKView) {
        makeTitleLabe()
        makePlayButton()
        makeHighScore()
    }

    func makeTitleLabe() {
        label.center = CGPoint(x: 205, y: 150)
        label.textAlignment = .center
        label.font = UIFont(name: "Marker Felt", size: 50.0)
        label.backgroundColor = UIColor.yellow
        label.textColor = UIColor.black
        label.text = "Doodle Jump"
        self.view?.addSubview(label)
    }

    func makePlayButton() {
        playButton.center = CGPoint(x: 205, y: 500)
        playButton.textAlignment = .center
        playButton.font = UIFont(name: "Marker Felt", size: 25.0)
        playButton.backgroundColor = UIColor.red
        playButton.textColor = UIColor.black
        playButton.text = "Play"
        self.view?.addSubview(playButton)
    }
    
    func makeHighScore() {
        highScoreLabel.center = CGPoint(x: 205, y: 300)
        highScoreLabel.textAlignment = .center
        highScoreLabel.font = UIFont(name: "Marker Felt", size: 25.0)
        highScoreLabel.backgroundColor = UIColor.orange
        highScoreLabel.textColor = UIColor.black
        highScoreLabel.text = "High Score: "
        self.view?.addSubview(highScoreLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let sceneTwo = SceneTwo()
        sceneTwo.scaleMode = .resizeFill
        self.view!.presentScene(sceneTwo, transition: SKTransition.fade(withDuration: 0.15))
        playButton.alpha = 0
        highScoreLabel.alpha = 0
    }
}
