//
//  BulletNode.swift
//  AtacaMexico
//
//  Created by Berganza on 26/9/15.
//  Copyright © 2015 Berganza. All rights reserved.
//

import Foundation


import UIKit
import SpriteKit

class BulletNode: SKNode {
    
    var thrust: CGVector = CGVectorMake(0, 0)
    
    
    override init() {
        super.init() //ponemos en práctica el método init (). Al igual que otros init () en esta aplicación, es aquí donde vamos a crear el gráfico de objetos para nuestro bala. Este consistirá en un simple “punto” ( . ). Mientras estamos en ello, vamos a también configurar la física para esta clase de creación y configuración de una instancia SKPhysicsBody y lo conectamos a si mismo. En el proceso, le decimos al nuevo cuerpo a que categoría pertenece y con qué categorías se debe comprobar las colisiones con este objeto.
        
        let dot = SKLabelNode(fontNamed: "Avenir")
        dot.fontColor = SKColor.cyanColor()
        dot.fontSize = 40
        dot.text = "."
        addChild(dot)
        
        
        let body = SKPhysicsBody(circleOfRadius: 1)
        body.dynamic = true
        body.categoryBitMask = PlayerMissileCategory
        body.contactTestBitMask = EnemyCategory
        body.collisionBitMask = EnemyCategory
        
        //*****
        body.fieldBitMask = GravityFieldCategory
        // Los demás cambios los haremos en el GameScene.swift
        //*****
        
        body.mass = 0.01
        
        physicsBody = body
        name = "Bullet \(self)"
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)
        let dx = aDecoder.decodeFloatForKey("thrustX")
        let dy = aDecoder.decodeFloatForKey("thrustY")
        thrust = CGVectorMake(CGFloat(dx), CGFloat(dy))
        
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeFloat(Float(thrust.dx), forKey: "thrustX")
        aCoder.encodeFloat(Float(thrust.dy), forKey: "thrustY")
    }
    
    //A continuación, vamos a crear el método de fábrica que crea una nueva bala y le da un vector de empuje (thrust) que el motor de física utilizará para impulsar la bala hacia su objetivo:
    class func bullet(from start: CGPoint, toward destination: CGPoint)  -> BulletNode {
        let bullet = BulletNode()
        bullet.position = start
        let movement = vectorBetweenPoints(start, p2: destination)
        let magnitude = vectorLength(movement)
        let scaleMovement = vectorMultiply(movement, m: 1/magnitude)
        let thrustMagnitude = CGFloat(100.0)
        bullet.thrust = vectorMultiply(scaleMovement, m: thrustMagnitude)
        
        
        //****
        
        // Sonidos
        bullet.runAction(SKAction.playSoundFileNamed("bip.wav", waitForCompletion: false))
        
        //****
        
        return bullet
        //Los cálculos básicos son: En primer lugar, determinar un vector de movimiento que apunta desde el punto de inicio para el destino, y luego determinamos su magnitud (longitud). Dividiendo el vector de movimiento por la magnitud que produce un vector unitario normalizado, un vector que apunta en la misma dirección que el original, pero que es exactamente una unidad de longitud (una unidad, en este caso, es el mismo como un "punto" en la pantalla -por ejemplo, dos pixeles en un dispositivo de Retina, un pixel en los dispositivos más antiguos).
        //La creación de un vector unitario es muy útil ya que lo podemos multiplicar por una magnitud fija (en este caso, 100) para determinar un vector de empuje uniforme de gran alcance, no importa lo lejos que el usuario toca la pantalla.
        
    }
    
    
    // La pieza final de código que tenemos que añadir a esta clase es este método, que aplica el empuje al cuerpo físico. Llamaremos a este una vez por frame, dentro de la escena:
    func applyRecurringForce() {
        physicsBody?.applyForce(thrust) // Ahora cambiamos a GameScene.swift para agregar las balas a la propia escena.
    }
    
    
    
    
    
}