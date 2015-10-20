//
//  Vector2.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 10/19/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation

public struct Vector2 {
    
    public var x: Float
    public var y: Float
    
    init() {
        x = 0
        y = 0
    }
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    // MARK: some convenient defaults
    static let one = Vector2(x: 1.0, y: 1.0)
    static let up = Vector3(x: 0.0, y: 1.0)
    static let down = Vector3(x: 0.0, y: -1.0)
    static let left = Vector3(x: -1.0, y: 0.0)
    static let right = Vector3(x: 1.0, y: 0.0)
    
    // MARK: Vector math functions
    
    static func angle(left: Vector3, right: Vector3) -> Float {
        // PLACEHOLDER
        print("Angle function is placeholder!")
        return 90.0
    }
    
    static func clampMagnitude(vector: Vector2, magnitude: Float) -> Vector2 {
        if vector.sqrMagnitude() > magnitude * magnitude {
            return vector.normalized() * magnitude
        }
        else {
            return vector
        }
    }
    // 2-component Vector technically doesn't have a Cross function
    // But apparently doing a Vector3.Cross with Z as 0 has some uses
    // TODO: Check again on implementation, add this
    /*
    static func cross(left: Vector3, right: Vector3) -> Vector3 {
        var cr = Vector3()
        cr.x = left.y * right.z - left.z * right.y
        cr.y = left.z * right.x - left.x * right.z
        cr.z = left.x * right.y - left.y * right.x
        
        return cr
    }
    */
    static func distance(left: Vector2, right: Vector2) -> Float {
        return (right - left).magnitude()
    }
    
    static func dot(left: Vector2, right: Vector2) -> Float {
        return left.x * right.x + left.y * right.y
    }
    
    static func lerp(from: Vector2, to: Vector2, var t: Float) -> Vector2 {
        if t < 0.0 { t = 0.0 }
        else if t > 1.0 { t = 1.0 }
        return from * (1 - t) + to * t
    }
    
    static func max(left: Vector2, right: Vector2) -> Vector2 {
        var max = left
        if right.x > max.x { max.x = right.x }
        if right.y > max.y { max.y = right.y }
        
        return max
    }
    
    static func min(left: Vector2, right: Vector2) -> Vector2 {
        var min = left
        if right.x < min.x { min.x = right.x }
        if right.y < min.y { min.y = right.y }
        
        return min
    }
    
    static func project(left: Vector2, right: Vector2) -> Vector2 {
        // TODO: Verify that this is correct
        return right * Vector2.dot(left, right: right)
    }
    
    static func reflect(vec: Vector2, planeNormal: Vector2) -> Vector2 {
        // PLACEHOLDER
        return vec
    }
    
    static func scale(left: Vector2, right: Vector2) -> Vector2 {
        var scaled = left
        scaled.x *= right.x
        scaled.y *= right.y
        return scaled
    }
    
    func sqrMagnitude() -> Float {
        return x * x + y * y
    }
    
    func magnitude() -> Float {
        let sqr = x * x + y * y
        return sqrt(sqr)
    }
    
    func normalized() -> Vector2 {
        let mag = magnitude()
        return self / mag
    }
    
    func toBuffer() -> [Float] {
        return [x, y]
    }
}

// MARK: Operator overloads

prefix func -(right: Vector2) -> Vector2 {
    return Vector2(x: -right.x, y: -right.y)
}

func +(left: Vector2, right: Vector2) -> Vector2 {
    return Vector2(x: left.x + right.x, y: left.y + right.y)
}

func +=(inout left: Vector2, right: Vector2) {
    left = left + right
}

func -(left: Vector2, right: Vector2) -> Vector2 {
    return Vector2(x: left.x - right.x, y: left.y - right.y)
}

func -=(inout left: Vector2, right: Vector2) {
    left = left - right
}

func *(left: Vector2, right: Float) -> Vector2 {
    return Vector2(x: left.x * right, y: left.y * right)
}

func *=(inout left: Vector2, right: Float) {
    left = left * right
}

func /(left: Vector2, right: Float) -> Vector2 {
    return Vector2(x: left.x / right, y: left.y / right)
}

func /=(inout left: Vector2, right: Float) {
    left = left / right
}