//
//  GameScene.swift
//  AtacaMexico
//
//  Created by Berganza on 25/9/15.
//  Copyright (c) 2015 Berganza. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, /*Delegado*/ SKPhysicsContactDelegate {
    
    
    private var levelNumber: UInt
    private var playerLives: Int {
        didSet {
            let lives = childNodeWithName("LivesLabel") as! SKLabelNode
            lives.text = "Vidas: \(playerLives)"
        }/// ******* Este fragmento de código utiliza el nombre que asociamos previamente con la etiqueta (en el método init(size:, levelNumber:)  ) para encontrar la etiqueta de nuevo y fijar un nuevo valor de texto.
        // Lanzamos el juego y, si el enemigo cae sobre el jugador, se reduce el número de vidas. Pero llegando a cero el juego no termina, sigue restando, incluso con valores negativos.
    }
    
    private var finished = false
    
    let playerNode: PlayerNode = PlayerNode()// Incorporamos el nodo del jugador
    
    let enemies = SKNode()// Incorporamos enemigos a la escena
    
    let playerBullets = SKNode() // Incorporamos las balas en un solo SKNode
    
    
    //*****
    let forceFields = SKNode()
    //*****
    
    
    
    
    
    
    class func scene(size:CGSize, levelNumber:UInt) -> GameScene {
        return GameScene(size: size, levelNumber: levelNumber)
    }//El primer método scene (size : , levelNumber :), nos da un método de fábrica que funciona como un atajo para la creación de un nivel y el establecimiento de su número de nivel a la vez.
    
    override convenience init(size:CGSize) {
        self.init(size: size, levelNumber: 1)
    }//En el segundo método init (), que anula el inicializador por defecto de la clase, pasando el control para el tercer método (y pasamos un valor predeterminado para el número de nivel)
    
    init(size:CGSize, levelNumber:UInt) {
        self.levelNumber = levelNumber
        self.playerLives = 5
        super.init(size: size)//Ese tercer método, a su vez llama al inicializador designado de la implementación de su superclase, después de establecer los valores y propiedades iniciales de levelNumber y playerLives.
        // Esto puede parecer una manera indirecta de hacer las cosas, pero es un patrón común cuando se quiere agregar nuevos inicializadores a una clase sin dejar de utilizar el inicializador designado de la clase.
        
        
        
        backgroundColor = SKColor.redColor()//Después de llamar al inicializador superclase, establecemos el color de fondo de la escena. Tener en cuenta que estamos usando una clase llamada SKColor en lugar de UIColor aquí. De hecho, SKColor no es realmente una clase en absoluto; es un alias de tipo “typeAlias” que está asignado (mapeado) a UIColor en una aplicación para iOS y NSColor para una aplicación OS X. Esto nos permite portar los juegos entre iOS y OS X un poco más fácil.
        
        
        
        ///creamos dos instancias de una clase llamada SKLabelNode. Esta es una clase práctica que funciona un poco como un UILabel, que nos permitirá añadir un poco de texto a la escena y permitirnos elegir un tipo de letra, fijamos un valor de texto, y especificamos algunas alineaciones. Creamos una etiqueta para mostrar el número de vidas en la parte superior derecha de la pantalla y otra que mostrará el número de nivel en la parte superior izquierda de la pantalla. Fijarse bien en el código que usamos para colocar estas etiquetas.
        let lives = SKLabelNode(fontNamed: "Avenir")
        lives.fontSize = 16
        lives.fontColor = SKColor.blueColor()
        lives.name = "LivesLabel"
        lives.text = "Vidas: \(playerLives)"
        lives.verticalAlignmentMode = .Top
        lives.horizontalAlignmentMode = .Right
        lives.position = CGPointMake(frame.size.width, frame.size.height)
        addChild(lives)
        
        let level = SKLabelNode(fontNamed: "Avenir")
        level.fontSize = 16
        level.fontColor = SKColor.blueColor()
        level.name = "LevelLabel"
        level.text = "Nivel: \(levelNumber)"
        level.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        level.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        level.position = CGPointMake(0, frame.height)
        addChild(level)
        
        
        // el símbolo del jugador ("Y" invertida) aparece cerca de la mitad inferior de la pantalla
        playerNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetHeight(frame) * 0.1)
        addChild(playerNode)//Lanzamos para comprobar
        
        addChild(enemies)
        spawnEnemies()//Lanzamos
        
        addChild(playerBullets)//Ahora estamos listos para codificar los lanzamientos de misiles reales. En el else del touchBegan
        
        //*****
        addChild(forceFields)
        createForceFields() // Implementamos el método
        //*****
        
        
        physicsWorld.gravity = CGVectorMake(0, -1)
        physicsWorld.contactDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        
        levelNumber = UInt(aDecoder.decodeIntegerForKey("level"))
        playerLives = aDecoder.decodeIntegerForKey("playerLives")
        super.init(coder: aDecoder)
    }//Añadimos los métodos init (coder:) y encodeWithCoder(coder:) porque todos los nodos de Sprite Kit, incluyendo SKScene, cumplen con el protocolo NSCoding. Esto nos obliga a utilizar override init (coder:),

    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(Int(levelNumber), forKey: "level")
        aCoder.encodeInteger(playerLives, forKey: "playerLives")
    }// por lo que también implementamos encodeWithCoder (coder:) por coherencia, a pesar de que no vamos a estar archivando el objeto de escena en esta aplicación. Vas a ver el mismo patrón en todas las subclases SKNode que creamos, aunque no vamos a implementar el método encodeWithCoder (coder:) cuando la subclase tiene ningún estado adicional de su propia, ya que la versión de la clase base hace todo lo que necesitaremos en ese caso.


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if location.y < CGRectGetHeight(frame) * 0.2 {
                let target = CGPointMake(location.x, playerNode.position.y)
                playerNode.moveToward(target)//El compilador se queja porque no hemos definido el método del jugador del nodo moveToward() todavía
                //El fragmento de código anterior utiliza cualquier lugar donde toque en la parte inferior de la pantalla,  la nueva ubicación hacia la que desea moverse el nodo del jugador. También le indica al nodo jugador que avance hacia ella. Así que cambiamos a PlayerNode.swift y añadimos la aplicación de dicho método
            } else {
                let bullet = BulletNode.bullet(from: playerNode.position, toward: location)
                playerBullets.addChild(bullet)//Eso añade la bala, pero ninguna de las balas que le añadamos en realidad se moverá a menos que le digamos mediante la aplicación que empuje cada frame. (nota: podemos lanzar la app y ver que se añade la bala pero cae hacia abajo)

            }
        }
    }
    
    func spawnEnemies() {
        let count = UInt(log(Float(levelNumber))) + levelNumber
        for var i: UInt = 0; i < count ; i++ {
            let enemy = EnemyNode()
            let size = frame.size
            let x = arc4random_uniform(UInt32(size.width * 0.8)) + UInt32(size.width * 0.1)
            let y = arc4random_uniform(UInt32(size.height * 0.5)) + UInt32(size.height * 0.5)
            enemy.position = CGPointMake(CGFloat(x), CGFloat(y))
            enemies.addChild(enemy)
        }
    }
    
    
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //*****
        if finished {
            return
        }
        updateBullets()
        
        //*****
        updateEnemies()
        if (!checkForGameOver()) {
            checkForNextLevel()
        }
        //checkForNextLevel()// Que ahora implementaremos
    }
    
    func updateBullets() {
        var bulletsToRemove:[BulletNode] = []
        for bullet in playerBullets.children as! [BulletNode] {
            // Remove any bullets that have move off-screen
            if !CGRectContainsPoint(frame, bullet.position) {
                // Mark bullet for removal
                bulletsToRemove.append(bullet)
                continue
            }
            // Apply thrust to remaining bullets
            bullet.applyRecurringForce()
        }
        playerBullets.removeChildrenInArray(bulletsToRemove)//Antes de decirle a cada bala que aplique su fuerza recurrente, también comprobamos si cada bala aún está en pantalla. Cualquier bala que se ha ido fuera de la pantalla se pone en un array temporal; y luego, al final, son borradas del nodo playerBullets. Tener en cuenta que este proceso de dos etapas es necesario porque el bucle de trabajo en este método es la iteración de todos los hijos en el nodo playerBullets. Hacer cambios en una colección mientras que estamos iterando sobre él nunca es una buena idea, y puede llevarnos fácilmente a un accidente.
        // Lanzamos la app
    }
    
    
    func updateEnemies() {
        var enemiesToRemove:[EnemyNode] = []
        for node in enemies.children as! [EnemyNode] {
            if !CGRectContainsPoint(frame, node.position) {
                // Mark enemy for removal
                enemiesToRemove.append(node)
                continue
            }//Que se encarga de eliminar cada enemigo del array enemigos de nivel cada vez que uno va fuera de la pantalla. Ahora vamos a modificar el método update(), diciéndole que se llame updateEnemies(), así como un nuevo método aún no hemos implementado:
        }
        enemies.removeChildrenInArray(enemiesToRemove)
    }
    
    func checkForNextLevel() {
        if enemies.children.isEmpty {
            goToNextLevel() // Y lo implementamos a continuación
        }
    }
    
    func goToNextLevel() {
        finished = true
        let label = SKLabelNode(fontNamed: "Avenir")
        label.text = "Nivel Completado"
        label.fontColor = SKColor.blackColor()
        label.fontSize = 40
        label.position = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5)
        addChild(label) // Lanzamos la app y comprobamos el resultado
        
        
        // Sonidos
        runAction(SKAction.playSoundFileNamed("electricidad.mp3", waitForCompletion: false))
        
        
        let nextLevel = GameScene(size: frame.size, levelNumber: levelNumber + 1)
        nextLevel.playerLives = playerLives
        view?.presentScene(nextLevel, transition: SKTransition.flipVerticalWithDuration(4.0))
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask {
            // Both bodies are in the same category
            let nodeA = contact.bodyA.node
            let nodeB = contact.bodyB.node
            // What do we do with these nodes?
            nodeA?.friendlyBumpFrom(nodeB!)
            nodeB?.friendlyBumpFrom(nodeA!) //Lo que hemos añadido aquí son las llamadas a nuestros nuevos métodos. Si el contacto es "fuego amigo” friendlyBumpFrom, si dos enemigos se chocan entre sí, se lo diremos a cada uno de ellos que recibió un golpe amistoso del otro. De lo contrario, después de averiguar quién atacó a quién, le decimos al attackee que ha sido atacado por otro objeto.
        } else {
            var attacker: SKNode
            var attackee:SKNode
            
            if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
                // Body A is attacking Body B
                attacker = contact.bodyA.node!
                attackee = contact.bodyB.node!
            } else {
                // Body B is attacking Body A
                attacker = contact.bodyB.node!
                attackee = contact.bodyA.node!
            }
        
            if attackee is PlayerNode {
                playerLives--
            }
            // What do we do with the attacker and the attackee?
            attackee.receiveAttacker(attacker, contact: contact)
            playerBullets.removeChildrenInArray([attacker])
            enemies.removeChildrenInArray([attacker])
        }
    }
    
    
    func triggerGameOver() {
        finished = true
        
        playerNode.removeFromParent()
        let transition = SKTransition.doorsOpenVerticalWithDuration(1)
        let gameOver = GameOverScene(size: frame.size)
        view?.presentScene(gameOver, transition: transition)
        
        
        // Sonidos
        runAction(SKAction.playSoundFileNamed("error.mp3", waitForCompletion: false))
        
        
    }
    
    func checkForGameOver() -> Bool {
        if playerLives == 0 {
            triggerGameOver()
            return true
        }
        return false
    }
    
    
    func createForceFields() {
        
        let fieldCount = 4
        let size = frame.size
        let sectionWidth = Int(size.width)/fieldCount
        
        for var i = 0; i < fieldCount; i++ {
            
            let x = CGFloat(i * sectionWidth) + CGFloat(arc4random_uniform(UInt32(sectionWidth)))
            let y = CGFloat(arc4random_uniform(UInt32(size.height * 0.25)) + UInt32(size.height * 0.25))
            
            let gravityField = SKFieldNode.radialGravityField() // Ver documentación SKFieldNode Class Reference
            gravityField.position = CGPointMake(x, y)
            gravityField.categoryBitMask = GravityFieldCategory
            gravityField.strength = 10
            gravityField.falloff = 2
            gravityField.region = SKRegion(size: CGSizeMake(size.width * 0.3,
                size.height * 0.1))
            forceFields.addChild(gravityField)
            
            let fieldLocationNode = SKLabelNode(fontNamed: "Courier")
            fieldLocationNode.fontSize = 24
            fieldLocationNode.fontColor = SKColor.whiteColor()
            fieldLocationNode.name = "GravityField"
            fieldLocationNode.text = "" // alt+g o alt+May+3
            fieldLocationNode.position = CGPointMake(x, y)
            forceFields.addChild(fieldLocationNode)
        }
        
        
    }

    

}



