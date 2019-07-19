//
//  GameScene.swift
//  Dev Team Doodle
//
//  Created by Madison Davis on 7/12/19.
//  Copyright © 2019 Madison Davis. All rights reserved.


var lastHighScore = Int()

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    let label = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width) / 2, y: UIScreen.main.bounds.minY + 100, width: 300, height: 60))
    let playButton = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width)/2, y: UIScreen.main.bounds.minY + 150, width: 100, height: 50))
    let highScoreLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width)/2, y: UIScreen.main.bounds.minY + 600, width: 300, height: 30))
    let defaults = UserDefaults.standard
    var numberOfTimesReset = 0
    var tempScore = 0
    
    override func didMove(to view: SKView) {
        createBackground()
        makeTitleLabe()
        makePlayButton()
        makeHighScoreLabel()
        if let saveData = defaults.object(forKey: "data") as? Int {
            lastHighScore = saveData
        }
        tempScore = score
        if tempScore > lastHighScore {
            lastHighScore = tempScore
            self.saveData()
        }
        highScoreLabel.text = "High Score: " + String(lastHighScore)
    }
    
    func createBackground() {
        let stars = SKTexture(imageNamed: "space")
        let starsBackground1 = SKSpriteNode(texture: stars)
        starsBackground1.size = CGSize(width: 414.0, height: 896.0)
        starsBackground1.position = CGPoint(x: frame.midX, y: frame.midY)
        starsBackground1.zPosition = -1
        addChild(starsBackground1)
    }
    
    func makeTitleLabe() {
        label.center = CGPoint(x: (UIScreen.main.bounds.width)/2 , y:  UIScreen.main.bounds.minY + 100)
        label.textAlignment = .center
        label.font = UIFont(name: "Marker Felt", size: 50.0)
        label.backgroundColor = UIColor.yellow
        label.textColor = UIColor.black
        label.text = "Space Jump"
        self.view?.addSubview(label)
    }
    
    func makePlayButton() {
        playButton.center = CGPoint(x: (UIScreen.main.bounds.width)/2, y: UIScreen.main.bounds.minY + 600)
        playButton.textAlignment = .center
        playButton.font = UIFont(name: "Marker Felt", size: 25.0)
        playButton.backgroundColor = UIColor.red
        playButton.textColor = UIColor.black
        playButton.text = "Play"
        self.view?.addSubview(playButton)
    }
    
    func makeHighScoreLabel() {
        highScoreLabel.center = CGPoint(x: (UIScreen.main.bounds.width)/2, y: UIScreen.main.bounds.minY + 150)
        highScoreLabel.textAlignment = .center
        highScoreLabel.font = UIFont(name: "Marker Felt", size: 25.0)
        highScoreLabel.backgroundColor = UIColor.orange
        highScoreLabel.textColor = UIColor.black
        highScoreLabel.text = "High Score: 000"
        self.view?.addSubview(highScoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let sceneTwo = SceneTwo()
        sceneTwo.scaleMode = .resizeFill
        self.view!.presentScene(sceneTwo, transition: SKTransition.fade(withDuration: 0.15))
        playButton.alpha = 0
        highScoreLabel.alpha = 0
        sceneTwo.scoreLabel.alpha = 1
        sceneTwo.oneTime = 1
    }
    
    func saveData() {
        defaults.set(tempScore, forKey: "data")
    }
}
