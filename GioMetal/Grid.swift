//
//  Grid.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 10/14/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation
import Cocoa
import MetalKit

class Grid {
    
    var vertexCount : Int
    var vertexBuffer : MTLBuffer
    var device : MTLDevice
    
    init (device: MTLDevice, size: Int) {
        // Generate grid vertices
        var vertexData = Array<Float>()
        
        let s1 = Float(-size)
        let s2 = Float(size)
        for i in -size...size {
            let coord = Float(i)
            // Draw origin lines much brighter than others
            let col : Float = i == 0 ? 1.0 : 0.4
            
            let A = Vertex(x: coord, y: 0, z: s1, s: 0, t: 0, r: col, g: col, b: col, a: col)
            let B = Vertex(x: coord, y: 0, z: s2, s: 0, t: 0, r: col, g: col, b: col, a: col)
            let C = Vertex(x: s1, y: 0, z: coord, s: 0, t: 0, r: col, g: col, b: col, a: col)
            let D = Vertex(x: s2, y: 0, z: coord, s: 0, t: 0, r: col, g: col, b: col, a: col)
            
            vertexData += A.buffer()
            vertexData += B.buffer()
            vertexData += C.buffer()
            vertexData += D.buffer()
        }
        
        // Add lines for world axes
        let A = Vertex(x: 0, y: 0, z: 0, s: 0, t: 0, r: 1, g: 0, b: 0, a: 1)
        let B = Vertex(x: 1, y: 0, z: 0, s: 0, t: 0, r: 1, g: 0, b: 0, a: 1)
        let C = Vertex(x: 0, y: 0, z: 0, s: 0, t: 0, r: 0, g: 1, b: 0, a: 1)
        let D = Vertex(x: 0, y: 1, z: 0, s: 0, t: 0, r: 0, g: 1, b: 0, a: 1)
        let E = Vertex(x: 0, y: 0, z: 0, s: 0, t: 0, r: 0, g: 0, b: 1, a: 1)
        let F = Vertex(x: 0, y: 0, z: 1, s: 0, t: 0, r: 0, g: 0, b: 1, a: 1)
        
        vertexData += A.buffer()
        vertexData += B.buffer()
        vertexData += C.buffer()
        vertexData += D.buffer()
        vertexData += E.buffer()
        vertexData += F.buffer()

        self.device = device
        
        let dataSize = vertexData.count * sizeofValue(vertexData[0])
        vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: [])
        vertexCount = (size * size) * 4 * 6
    }
}