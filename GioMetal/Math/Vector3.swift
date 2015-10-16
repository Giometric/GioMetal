//
//  Vector3.swift
//  HelloMetal
//
//  Created by Giovanni Sabella on 9/2/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation

public struct Vector3 {
    
    public var x: Float
    public var y: Float
    public var z: Float
    
    init() {
        x = 0
        y = 0
        z = 0
    }
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
        self.z = 0.0
    }
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    // Mark some convenient defaults
    static let one = Vector3(x: 1.0, y: 1.0, z: 1.0)
    static let forward = Vector3(x: 0.0, y: 0.0, z: 1.0)
    static let back = Vector3(x: 0.0, y: 0.0, z: -1.0)
    static let up = Vector3(x: 0.0, y: 1.0, z: 0.0)
    static let down = Vector3(x: 0.0, y: -1.0, z: 0.0)
    static let left = Vector3(x: -1.0, y: 0.0, z: 0.0)
    static let right = Vector3(x: 1.0, y: 0.0, z: 0.0)
    
    // Mark Vector math functions
    
    static func angle(left: Vector3, right: Vector3) -> Float {
        // PLACEHOLDER
        print("Angle function is placeholder!")
        return 90.0
    }
    
    static func clampMagnitude(vector: Vector3, magnitude: Float) -> Vector3 {
        if vector.sqrMagnitude() > magnitude * magnitude {
            return vector.normalized() * magnitude
        }
        else {
            return vector
        }
    }
    
    static func cross(left: Vector3, right: Vector3) -> Vector3 {
        var cr = Vector3()
        cr.x = left.y * right.z - left.z * right.y
        cr.y = left.z * right.x - left.x * right.z
        cr.z = left.x * right.y - left.y * right.x
        
        return cr
    }
    
    static func distance(left: Vector3, right: Vector3) -> Float {
        return (right - left).magnitude()
    }
    
    static func dot(left: Vector3, right: Vector3) -> Float {
        return left.x * right.x + left.y * right.y + left.z * right.z
    }
    
    static func lerp(from: Vector3, to: Vector3, var t: Float) -> Vector3 {
        if t < 0.0 { t = 0.0 }
        else if t > 1.0 { t = 1.0 }
        return from * (1 - t) + to * t
    }
    
    static func max(left: Vector3, right: Vector3) -> Vector3 {
        var max = left
        if right.x > max.x { max.x = right.x }
        if right.y > max.y { max.y = right.y }
        if right.z > max.z { max.z = right.z }
        
        return max
    }
    
    static func min(left: Vector3, right: Vector3) -> Vector3 {
        var min = left
        if right.x < min.x { min.x = right.x }
        if right.y < min.y { min.y = right.y }
        if right.z < min.z { min.z = right.z }
        
        return min
    }
    
    static func project(left: Vector3, right: Vector3) -> Vector3 {
        // TODO: Verify that this is correct
        return right * Vector3.dot(left, right: right)
    }
    
    static func reflect(vec: Vector3, planeNormal: Vector3) -> Vector3 {
        // PLACEHOLDER
        return vec
    }
    
    static func scale(left: Vector3, right: Vector3) -> Vector3 {
        var scaled = left
        scaled.x *= right.x
        scaled.y *= right.y
        scaled.z *= right.z
        return scaled
    }
    
    func sqrMagnitude() -> Float {
        return x * x + y * y + z * z
    }
    
    func magnitude() -> Float {
        let sqr = x * x + y * y + z * z
        return sqrt(sqr)
    }
    
    func normalized() -> Vector3 {
        let mag = magnitude()
        return self / mag
    }
    
    func toBuffer() -> [Float] {
        return [x, y, z]
    }
}

// Mark Operator overloads

prefix func -(right: Vector3) -> Vector3 {
    return Vector3(x: -right.x, y: -right.y, z: -right.z)
}

func +(left: Vector3, right: Vector3) -> Vector3 {
    return Vector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

func +=(inout left: Vector3, right: Vector3) {
    left = left + right
}

func -(left: Vector3, right: Vector3) -> Vector3 {
    return Vector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
}

func -=(inout left: Vector3, right: Vector3) {
    left = left - right
}

func *(left: Vector3, right: Float) -> Vector3 {
    return Vector3(x: left.x * right, y: left.y * right, z: left.z * right)
}

func *=(inout left: Vector3, right: Float) {
    left = left * right
}

func /(left: Vector3, right: Float) -> Vector3 {
    return Vector3(x: left.x / right, y: left.y / right, z: left.z / right)
}

func /=(inout left: Vector3, right: Float) {
    left = left / right
}