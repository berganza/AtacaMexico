//
//  GameViewController.swift
//  AtacaMexico
//
//  Created by Berganza on 25/9/15.
//  Copyright (c) 2015 Berganza. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //if let scene = GameScene(fileNamed:"GameScene") {
        
        
        //**
        //let scene = GameScene(size: view.frame.size, levelNumber: 1)//En lugar de cargar la escena desde el archivo de escena, estamos usando la escena (size: , levelNumber:) método que acabamos de agregar a GameScene para crear e inicializar la escena y que sea del mismo tamaño que la SKView
        //**
        
        //******
        let scene = StartScene(size: view.frame.size)
        //******
        
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true //Podemos poner a false
            skView.showsNodeCount = true //Podemos poner a false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill    //view y scene son del mismo tamaño, ya no hay ninguna necesidad de establecer la propiedad scaleMode de la escena, así que se puede eliminar la línea de código que hace eso.
            
            skView.presentScene(scene)
        //}
        }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }//Este código hace que la barra de estado iOS desaparezca mientras nuestro juego se esté ejecutando. La plantilla Xcode incluye este método porque ocultar la barra de estado suele ser habitual en este tipo de juegos de acción.
}
