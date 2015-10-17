//
//  Mat4.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 10/13/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation

// 4x4 Matrix, stored in Row-order.
// Multiplication with Vectors is done with Row-Vectors (bottom row is translation)
public struct Mat4 : CustomStringConvertible {
    static let size : Int = 16
    static let bufferSize : Int = size * sizeof(Float)
    
    private var m : [Float]
    
    public var description : String {
        get {
            return "[\(m[0])    \(m[1])    \(m[2])    \(m[3])]\n" +
                   "[\(m[4])    \(m[5])    \(m[6])    \(m[7])]\n" +
                   "[\(m[8])    \(m[9])    \(m[10])    \(m[11])]\n" +
                   "[\(m[12])    \(m[13])    \(m[14])    \(m[15])]"
        }
    }
    
    subscript(index: Int) -> Float {
        get {
            if index > -1 && index < Mat4.size { return m[index] }
            else {
                print("Attempted to get Matrix element with index out of range!")
                return 0.0
            }
        }
        set {
            if index > -1 && index < Mat4.size { m[index] = newValue; }
            else { print("Attempted to set Matrix element with index out of range!") }
        }
    }
    
    init() {
        m = Array<Float>(count: Mat4.size, repeatedValue: 0.0)
    }
    
    static func identity() -> Mat4 {
        var ret = Mat4()
        ret[0] = 1
        ret[5] = 1
        ret[10] = 1
        ret[15] = 1
        return ret
    }
    
    static func perspective(fov: Float, aspect: Float, nearZ: Float, farZ: Float) -> Mat4 {
        var p = Mat4.identity()
        if fov <= 0.0 || aspect == 0.0 { return p }
        
        let depth = farZ - nearZ
        let oneOverDepth = 1.0 / depth
        
        p[5] = 1.0 / tan(0.5 * (fov * MTMath.deg2Rad))
        p[0] = p[5] / aspect
        p[10] = farZ * oneOverDepth
        p[11] = 1.0
        p[14] = (-farZ * nearZ) * oneOverDepth
        p[15] = 0.0
        return p
    }
    
    static func lookAt(eyePos: Vector3, target: Vector3, up: Vector3) -> Mat4 {
        // Create basis vectors
        let lookFwd = (target - eyePos).normalized()
        let lookRight = Vector3.cross(up, right: lookFwd).normalized()
        let lookUp = Vector3.cross(lookFwd, right: lookRight)
        
        var lookMat = Mat4.identity()
        lookMat.setColumn(0, vec3: lookRight)
        lookMat.setColumn(1, vec3: lookUp)
        lookMat.setColumn(2, vec3: lookFwd)
        
        // Set translation directly
        var invTrans = Vector3()
        invTrans.x = -Vector3.dot(lookRight, right: eyePos)
        invTrans.y = -Vector3.dot(lookUp, right: eyePos)
        invTrans.z = -Vector3.dot(lookFwd, right: eyePos)
        lookMat.setRow(3, vec3: invTrans)
        
        return lookMat
    }
    
    static func fpsView(eyePos: Vector3, pitch: Float, yaw: Float) -> Mat4 {
        
        let pitchRad = pitch * MTMath.deg2Rad
        let yawRad = yaw * MTMath.deg2Rad
        let cosPitch = cos(pitchRad)
        let sinPitch = sin(pitchRad)
        let cosYaw = cos(yawRad)
        let sinYaw = sin(yawRad)
        
        // Create basis vectors
        let lookRight = Vector3(x: cosYaw, y: 0.0, z: -sinYaw)
        let lookUp = Vector3(x: sinYaw * sinPitch, y: cosPitch, z: cosYaw * sinPitch)
        let lookFwd = Vector3(x: sinYaw * cosPitch, y: -sinPitch, z: cosPitch * cosYaw)
        
        var lookMat = Mat4.identity()
        lookMat.setColumn(0, vec3: lookRight)
        lookMat.setColumn(1, vec3: lookUp)
        lookMat.setColumn(2, vec3: lookFwd)
        
        var invTrans = Vector3()
        invTrans.x = -Vector3.dot(lookRight, right: eyePos)
        invTrans.y = -Vector3.dot(lookUp, right: eyePos)
        invTrans.z = -Vector3.dot(lookFwd, right: eyePos)
        lookMat.setRow(3, vec3: invTrans)
        
        return lookMat
    }
    
    static func scale(scale: Vector3) -> Mat4 {
        var mat = Mat4()
        mat[0] = scale.x
        mat[5] = scale.y
        mat[10] = scale.z
        mat[15] = 1.0
        return mat
    }
    
    static func rotation(rotation: Vector3) -> Mat4 {
        var mat = Mat4()
        let rot = rotation * MTMath.deg2Rad
        
        let sinX = sin(rot.x)
        let sinY = sin(rot.y)
        let sinZ = sin(rot.z)
        
        let cosX = cos(rot.x)
        let cosY = cos(rot.y)
        let cosZ = cos(rot.z)
        
        mat[0] = cosY * cosZ
        mat[4] = cosZ * sinX * sinY - cosX * sinZ
        mat[8] = cosX * cosZ * sinY + sinX * sinZ
        
        mat[1] = cosY * sinZ
        mat[5] = cosX * cosZ + sinX * sinY * sinZ
        mat[9] = -cosZ * sinX + cosX * sinY * sinZ
        
        mat[2] = -sinY
        mat[6] = cosY * sinX
        mat[10] = cosX * cosY
        /*
        mat[0] = cosY * cosZ
        mat[1] = cosZ * sinX * sinY - cosX * sinZ
        mat[2] = cosX * cosZ * sinY + sinX * sinZ
        
        mat[4] = cosY * sinZ
        mat[5] = cosX * cosZ + sinX * sinY * sinZ
        mat[6] = -cosZ * sinX + cosX * sinY * sinZ
        
        mat[8] = -sinY
        mat[9] = cosY * sinX
        mat[10] = cosX * cosY
        */
        mat[15] = 1.0 // ?
        return mat
    }
    
    static func trs(position: Vector3, rotation: Vector3, scale: Vector3) -> Mat4 {
        var mat = Mat4.scale(scale)
        mat *= Mat4.rotation(rotation)
        
        mat[12] = position.x
        mat[13] = position.y
        mat[14] = position.z
        
        return mat
    }
    
    func getColumn(column: Int) -> Vector3 {
        if column < 0 || column > 3 { return Vector3() }
        return Vector3(x: m[column], y: m[column + 4], z: m[column + 8])
    }
    
    func getRow(row: Int) -> Vector3 {
        if row < 0 || row > 3 { return Vector3() }
        let rowIndex = row * 4;
        return Vector3(x: m[rowIndex], y: m[rowIndex + 1], z: m[rowIndex + 2])
    }
    
    mutating func setColumn(column: Int, vec3: Vector3) {
        if column < 0 || column > 3 { return }
        m[column] = vec3.x
        m[column + 4] = vec3.y
        m[column + 8] = vec3.z
    }
    
    mutating func setRow(row: Int, vec3: Vector3) {
        if row < 0 || row > 3 { return }
        let rowIndex = row * 4;
        m[rowIndex] = vec3.x
        m[rowIndex + 1] = vec3.y
        m[rowIndex + 2] = vec3.z
    }
    /*
    mutating func setTrs(position: Vector3, rotation: Vector3, scale: Vector3) {
        
        self = Mat4.scale(scale) * Mat4.rotation(rotation)
        
        m[12] = position.x
        m[13] = position.y
        m[14] = position.z
        m[15] = 1.0
    }
    */
    func inverse() -> Mat4 {
        // TODO: Implement this
        return self
    }
    
    func transpose() -> Mat4 {
        var ret = self
        ret[1] = self[4]
        ret[2] = self[8]
        ret[3] = self[12]
        ret[4] = self[1]
        ret[6] = self[9]
        ret[7] = self[13]
        ret[8] = self[2]
        ret[9] = self[6]
        ret[11] = self[14]
        ret[12] = self[3]
        ret[13] = self[7]
        ret[14] = self[11]
        return ret
    }
    
    func multiplyPoint(point: Vector3) -> Vector3 {
        var v = Vector3()
        v.x = m[0] * point.x + m[4] * point.y + m[8] * point.z + m[12]
        v.y = m[1] * point.x + m[5] * point.y + m[9] * point.z + m[13]
        v.z = m[2] * point.x + m[6] * point.y + m[10] * point.z + m[14]
        return v
    }
    
    func multiplyDirection(dir: Vector3) -> Vector3 {
        var v = Vector3()
        v.x = m[0] * dir.x + m[4] * dir.y + m[8] * dir.z
        v.y = m[1] * dir.x + m[5] * dir.y + m[9] * dir.z
        v.z = m[2] * dir.x + m[6] * dir.y + m[10] * dir.z
        return v
    }
    
    func toBuffer() -> [Float] {
        return m
    }
}

func *(left: Mat4, right: Mat4) -> Mat4 {
    var ret = Mat4()
    
    ret[0] = left[0] * right[0] + left[1] * right[4] + left[2] * right[8] + left[3] * right[12]
    ret[1] = left[0] * right[1] + left[1] * right[5] + left[2] * right[9] + left[3] * right[13]
    ret[2] = left[0] * right[2] + left[1] * right[6] + left[2] * right[10] + left[3] * right[14]
    ret[3] = left[0] * right[3] + left[1] * right[7] + left[2] * right[11] + left[3] * right[15]
    
    ret[4] = left[4] * right[0] + left[5] * right[4] + left[6] * right[8] + left[7] * right[12]
    ret[5] = left[4] * right[1] + left[5] * right[5] + left[6] * right[9] + left[7] * right[13]
    ret[6] = left[4] * right[2] + left[5] * right[6] + left[6] * right[10] + left[7] * right[14]
    ret[7] = left[4] * right[3] + left[5] * right[7] + left[6] * right[11] + left[7] * right[15]
    
    ret[8] = left[8] * right[0] + left[9] * right[4] + left[10] * right[8] + left[11] * right[12]
    ret[9] = left[8] * right[1] + left[9] * right[5] + left[10] * right[9] + left[11] * right[13]
    ret[10] = left[8] * right[2] + left[9] * right[6] + left[10] * right[10] + left[11] * right[14]
    ret[11] = left[8] * right[3] + left[9] * right[7] + left[10] * right[11] + left[11] * right[15]
    
    ret[12] = left[12] * right[0] + left[13] * right[4] + left[14] * right[8] + left[15] * right[12]
    ret[13] = left[12] * right[1] + left[13] * right[5] + left[14] * right[9] + left[15] * right[13]
    ret[14] = left[12] * right[2] + left[13] * right[6] + left[14] * right[10] + left[15] * right[14]
    ret[15] = left[12] * right[3] + left[13] * right[7] + left[14] * right[11] + left[15] * right[15]
    
    return ret
}

func *=(inout left: Mat4, right: Mat4) {
    left = left * right
}

func *(left: Mat4, right: Vector3) -> Vector3 {
    // Essentially an implicit conversion to Vector4, where the w value is 1
    // Maybe should do w as 0 (would multiply direction instead of point)
    return left.multiplyPoint(right)
}