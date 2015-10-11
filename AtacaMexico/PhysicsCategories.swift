//
//  PhysicsCategories.swift
//  AtacaMexico
//
//  Created by Berganza on 26/9/15.
//  Copyright © 2015 Berganza. All rights reserved.
//

import Foundation

let PlayerCategory: UInt32 = 1 << 1
let EnemyCategory: UInt32 = 1 << 2
let PlayerMissileCategory: UInt32 = 1 << 3

//Aquí declaramos tres constantes de categoría. Tenga en cuenta que las categorías funcionan como una máscara de bits, por lo que cada uno de ellas debe ser una potencia de dos. Podemos hacer esto fácilmente por desplazamiento de bit. Estos se configuran como una máscara de bits con el fin de simplificar la API del motor de física un poco. Con máscaras de bits, podemos lógicamente tener varios valores juntos. Esto nos permite utilizar una sola llamada a la API para decirle al motor de física cómo hacer frente a las colisiones entre muchas capas diferentes. Vamos a ver esto en acción pronto.


let GravityFieldCategory:UInt32 = 1 << 4
//Un campo actúa en un nodo si el fieldBitMask en el cuerpo de la física del nodo tiene cualquier categoría en común con el campo categoryBitMask. Por defecto, fieldBitMask de un cuerpo físico tiene todas las categorías establecidas. Dado que no queremos que los enemigos sean afectados por el campo de gravedad, necesitamos despejar su fieldBitMask añadiendo el código correspondiente en EnemyNode.swift