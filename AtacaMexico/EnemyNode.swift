//
//  EnemyNode.swift
//  AtacaMexico
//
//  Created by Berganza on 26/9/15.
//  Copyright © 2015 Berganza. All rights reserved.
//

import Foundation




import SpriteKit
import UIKit


class EnemyNode: SKNode {
    override init() {
        super.init()
        name = "Enemy \(self)"
        initNodeGraph()
        
        
        //**
        initPhysicsBody()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initNodeGraph(){
        let enemigo = SKLabelNode(fontNamed: "Avenir")
        enemigo.fontColor = SKColor.blackColor()
        enemigo.fontSize = 80
        enemigo.text = "x"
        addChild(enemigo)
        //Ahora vamos a hacer que algunos enemigos aparezcan en la escena haciendo algunos cambios a GameScene.swift. En primer lugar, añadir una nueva propiedad para situar a los enemigos que se sumarán a este nivel:
    }
    
    func initPhysicsBody() {
        let body = SKPhysicsBody(rectangleOfSize: CGSizeMake(40, 40))
        body.affectedByGravity = false
        body.categoryBitMask = EnemyCategory
        body.contactTestBitMask = PlayerCategory | EnemyCategory
        body.mass = 0.2
        body.angularDamping = 0
        body.linearDamping = 0
        
        
        
        //*****
        body.fieldBitMask = 0
        // Hacemos lo mismo en el PlayerNode.swift
        //*****
        
        
        physicsBody = body
        // A continuación, seleccionamos PlayerNode.swift, donde se va a hacer algo bastante similar.
    }
    
    override func friendlyBumpFrom(node: SKNode) {
        physicsBody?.affectedByGravity = true
    }//inicia la gravedad para el enemigo afectado. Así, si un enemigo está en movimiento y se tropieza con otro, el segundo enemigo notará la gravedad y comenzará a caer hacia abajo.
    
    override func receiveAttacker(attacker: SKNode, contact: SKPhysicsContact) {
        physicsBody?.affectedByGravity = true
        let force = vectorMultiply((attacker.physicsBody?.velocity)!, m: contact.collisionImpulse)
        let myContac = scene!.convertPoint(contact.contactPoint, toNode:self)
        physicsBody?.applyForce(force, atPoint: myContac)
    // se llama si el enemigo es alcanzado por una bala, se convierte por primera vez en la gravedad para el enemigo. Sin embargo, también utiliza los datos de contacto que se pasó de averiguar dónde se produjo el contacto y se aplica una fuerza a ese punto, dándole un impulso adicional en la dirección que la bala fue disparada.
    //Ejecutamos la app y comprobamos
        
        
        // Partículas
        let path = NSBundle.mainBundle().pathForResource("MissileExplosion", ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        explosion.numParticlesToEmit = 20
        explosion.position = contact.contactPoint
        scene?.addChild(explosion)
        
        
        // Sonidos
        runAction(SKAction.playSoundFileNamed("bombaPequena.mp3", waitForCompletion: false))
        
    }
}








