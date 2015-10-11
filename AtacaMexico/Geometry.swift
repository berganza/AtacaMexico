//
//  Geometry.swift
//  AtacaMexico
//
//  Created by Berganza on 26/9/15.
//  Copyright © 2015 Berganza. All rights reserved.
//

import Foundation

import UIKit
import SpriteKit
/*****************

Estos son implementaciones simples de algunas operaciones comunes que son útiles en muchos juegos: vectores multiplicadores, creando vectores apuntando desde un punto a otro, y el cálculo de distancias.

*****************/


// Takes a CGVector and CGFloat
// Returns a new CGFloat where each component of v has been multiplied by m
func vectorMultiply(v: CGVector, m: CGFloat) -> CGVector {
    return CGVectorMake(v.dx * m, v.dy * m)
}

// Takes two CGPoints
// Returns a CGVector representing a direction from p1 to p2
func vectorBetweenPoints(p1: CGPoint, p2: CGPoint) -> CGVector{
    return CGVectorMake(p2.x - p1.x, p2.y - p1.y)
}

// Takes a CGVector
// Returns a CGFloat containing the length of the vector, calculated using Pythagoras' theorem
func vectorLength(v: CGVector) -> CGFloat {
    return CGFloat(sqrtf(powf(Float(v.dx), 2) + powf(Float(v.dy), 2)))
}

// Takes two CGPoints. Returns a CGFloat containing the distance between them, calculated wwith Pythagoras' Theorem
func pointDistance(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return CGFloat(sqrtf(powf(Float(p2.x - p1.x), 2) + powf(Float(p2.y - p1.y), 2)))
}

