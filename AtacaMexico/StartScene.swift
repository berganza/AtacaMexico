//
//  StartScene.swift
//  AtacaMexico
//
//  Created by Berganza on 27/9/15.
//  Copyright © 2015 Berganza. All rights reserved.
//

import Foundation



import SpriteKit

class StartScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.blueColor()
        
        let topLabel = SKLabelNode(fontNamed: "Avenir")
        topLabel.text = "Mexico Ataca"
        topLabel.fontColor = SKColor.whiteColor()
        topLabel.fontSize = 50
        topLabel.position = CGPointMake(frame.size.width/2, frame.size.height * 0.7)
        addChild(topLabel)
        
        let bottomLabel = SKLabelNode(fontNamed: "Avenir")
        bottomLabel.text = "Pulse para comenzar una partida"
        bottomLabel.fontColor = SKColor.whiteColor()
        bottomLabel.fontSize = 20
        bottomLabel.position = CGPointMake(frame.size.width/2, frame.size.height * 0.3)
        addChild(bottomLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent!) {
            let transition = SKTransition.doorwayWithDuration(1.0)
            let game = GameScene(size:frame.size)
            view!.presentScene(game, transition: transition)
        
        
        //*****
        // Sonidos
        runAction(SKAction.playSoundFileNamed("electricidad.mp3", waitForCompletion: false))
        //*****
        
    }
    // Volvemos a GameOverScene.swift para forzar a la pantalla a realizar la transición
}



