//
//  GameOverScene.swift
//  AtacaMexico
//
//  Created by Berganza on 27/9/15.
//  Copyright © 2015 Berganza. All rights reserved.
//

import Foundation



import UIKit
import SpriteKit

class GameOverScene: SKScene {
    override init(size: CGSize) {
        super.init(size:size)
        backgroundColor = SKColor.yellowColor()
        let text = SKLabelNode(fontNamed: "Avenir")
        text.text = "Game Over"
        text.fontColor = SKColor.purpleColor()
        text.fontSize = 50
        text.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        addChild(text)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //Ahora vamos a cambiar de nuevo a GameScene.swift. La acción básica de qué hacer cuando el juego termina se define por un nuevo método llamado triggerGameOver().
    
    
    //******
    override func didMoveToView(view: SKView) {
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, 3 * Int64(NSEC_PER_SEC)),
            dispatch_get_main_queue()) {
                let transition = SKTransition.flipVerticalWithDuration(4)
                let start = StartScene(size: self.frame.size)
                view.presentScene(start, transition: transition)
        }
    }
}







