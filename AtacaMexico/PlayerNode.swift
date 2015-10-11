//
//  PlayerNode.swift
//  AtacaMexico
//
//  Created by Berganza on 26/9/15.
//  Copyright © 2015 Berganza. All rights reserved.
//

import Foundation


import UIKit
import SpriteKit

class PlayerNode: SKNode {
    override init() {
        super.init()
        name = "Player \(self)"
        initNodeGraph()
        
        // **
        initPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func initNodeGraph() {
        let label = SKLabelNode(fontNamed: "Avenir")
        label.fontColor = SKColor.whiteColor()   
        label.fontSize = 80
        label.text = "Y"
        label.zRotation = CGFloat(M_PI)// Giramos la letra Y
        label.name = "label"
        self.addChild(label)// Ahora regresmos a GameScene.swift. Aquí, vamos a añadir una instancia de PlayerNode a la escena.
    }
    
    func moveToward(location:CGPoint) {
        removeActionForKey("movement")
        let distance = pointDistance(position, p2: location)// Nos dará error
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let duration = NSTimeInterval(2 * distance/screenWidth)
        runAction(SKAction.moveTo(location, duration: duration), withKey:"movement")
        //Este método compara la nueva ubicación de la posición actual y calcula la distancia y el número de píxeles para moverse. A continuación, vemos cuánto tiempo tomará el movimiento, utilizando una constante numérica para ajustar la velocidad del movimiento global.
        //Por último, se crea una SKAction para hacer que se produzca el movimiento. SKAction es una parte de SpriteKit que sabe cómo hacer cambios a los nodos en tiempo, lo que le permite animar fácilmente a un nodo de posición, tamaño, rotación, transparencia y más. En este caso, le estamos diciendo al nodo jugador que ejecute una acción simple de movimiento con una duración determinada, y luego asignamos esa acción con la clave “movimiento".
        //Como se ve, la palabra clave es la misma que la clave utilizada en la primera línea de este método para eliminar una acción. Comenzamos este método mediante la eliminación de cualquier acción existente con la misma clave, de modo que el usuario puede aprovechar varios lugares de manera rápida sin competir con otras acciones que están tratando de moverse a diferentes lugares.
        
        // Xcode no puede encontrar ninguna función llamada pointDistance (). Esta es una de varias funciones geométricas simples que nuestra aplicación va a utilizar para realizar cálculos con puntos, vectores y floats. Vamos a poner esto en su lugar ahora. Creamos un nuevo archivo de tipo Swift y le llamamos Geometry.swift Ponemos el siguiente contenido...
    }
    
    
    
    func initPhysicsBody() {
        let body = SKPhysicsBody(rectangleOfSize: CGSizeMake(20, 20))
        body.affectedByGravity = false
        body.categoryBitMask = PlayerCategory
        body.contactTestBitMask = EnemyCategory
        body.collisionBitMask = 0
        
        //*****
        body.fieldBitMask = 0
        // Parecido en el BulletNode.swift
        //*****
        
        
        physicsBody = body
        //En este punto, se puede ejecutar la aplicación y ver que las balas ahora tienen la capacidad para golpear a los enemigos en el espacio. 
        // Se va el enemigo y terminamos el juego, esto nos da pie para agregar la gestión de los niveles del juego.

    }
    
    override func receiveAttacker(attacker: SKNode, contact: SKPhysicsContact) {
        let path = NSBundle.mainBundle().pathForResource("EnemyExplosion", ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        explosion.numParticlesToEmit = 50
        explosion.position = contact.contactPoint
        scene?.addChild(explosion)
        
        
        // Sonidos
        runAction(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        
    }
    
}










