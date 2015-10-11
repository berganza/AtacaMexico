//
//  SKNode+Extra.swift
//  AtacaMexico
//
//  Created by Berganza on 27/9/15.
//  Copyright © 2015 Berganza. All rights reserved.
//

import Foundation



import SpriteKit

extension SKNode {
    func receiveAttacker(attacker: SKNode, contact: SKPhysicsContact) {
        //  Default implementation does nothing
    }
    func friendlyBumpFrom(node: SKNode) {
        //Default implementation does nothing
    } // Ahora regresamos a GameScene.swift para terminar la parte de la manipulación de las colisiones.
}