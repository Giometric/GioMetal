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
        // TODO: Would be better to render these as lines, modify to make it so (would be less verts too)
        var vertexData = Array<Float>()
        
        for i in -size..<size {
            let x = Float(i)
            for j in -size..<size {
                let y = Float(j)
                
                let A = Vertex(x: x, y: 0.0, z: y + 1.0, s:  0.0, t:  1.0, r:  1.0, g:  1.0, b:  1.0, a:  1.0)
                let B = Vertex(x: x, y: 0.0, z: y, s:  0.0, t:  0.0, r:  1.0, g:  1.0, b:  1.0, a:  1.0)
                let C = Vertex(x: x + 1.0, y: 0, z: y, s:  1.0, t:  0.0, r:  1.0, g:  1.0, b:  1.0, a:  1.0)
                let D = Vertex(x: x + 1.0, y: 0, z: y + 1.0, s:  1.0, t:  1.0, r:  1.0, g:  1.0, b:  1.0, a:  1.0)
                
                vertexData += A.buffer()
                vertexData += B.buffer()
                vertexData += C.buffer()
                vertexData += D.buffer()
                vertexData += A.buffer()
                vertexData += C.buffer()
            }
        }
        
        self.device = device
        
        let dataSize = vertexData.count * sizeofValue(vertexData[0])
        vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: [])
        vertexCount = (size * size) * 4 * 6
    }
}