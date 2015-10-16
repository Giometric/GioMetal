//
//  Node.swift
//  HelloMetal
//
//  Created by Giovanni Sabella on 8/31/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation
import Metal
import MetalKit

// Needs a lot of work, shouldn't need an MTLDevice reference, etc
// Will most likely be re-worked into a class that simply stores Transform data

class Node {
    let name : String
    var vertexCount : Int
    var vertexBuffer : MTLBuffer
    var device : MTLDevice
    var texture : MTLTexture
    lazy var samplerState : MTLSamplerState? = Node.defaultSampler(self.device)
    
    var position : Vector3
    var rotation : Vector3 // TODO: Implement Quaternion rotations
    var scale : Vector3
    
    private var modelMat : Mat4 = Mat4.identity()
    
    init(name: String, vertices: Array<Vertex>, device: MTLDevice, texture: MTLTexture) {
        var vertexData = Array<Float>()
        for vertex in vertices {
            vertexData += vertex.buffer()
        }
        
        let dataSize = vertexData.count * sizeofValue(vertexData[0])
        vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: [])
        
        self.position = Vector3()
        self.rotation = Vector3()
        self.scale = Vector3()
        
        self.name = name
        vertexCount = vertices.count
        
        self.device = device
        self.texture = texture
    }
    
    func update(delta: Float){
        let spin = Vector3(x: 0.0, y: 22.5, z: 0.0) * delta
        self.rotation += spin
        
        if rotation.x >= 360.0 {
            rotation.x -= 360.0
        }
        if rotation.y >= 360.0 {
            rotation.y -= 360.0
        }
        if rotation.z >= 360.0 {
            rotation.z -= 360.0
        }
        
        modelMat = Mat4.trs(position, rotation: rotation, scale: scale)
    }
    
    func modelMatrix() -> Mat4
    {
        return modelMat
    }
    
    func right() -> Vector3
    {
        return modelMat.getColumn(0)
    }
    
    func up() -> Vector3
    {
        return modelMat.getColumn(1)
    }
    
    func forward() -> Vector3
    {
        return modelMat.getColumn(2)
    }
    
    class func defaultSampler(device: MTLDevice) -> MTLSamplerState {
        let samplerDescriptor : MTLSamplerDescriptor? = MTLSamplerDescriptor()
        
        if let sampler = samplerDescriptor {
            sampler.minFilter = .Linear
            sampler.magFilter = .Linear
            sampler.mipFilter = .Linear
            sampler.maxAnisotropy = 1
            sampler.sAddressMode = .ClampToEdge
            sampler.tAddressMode = .ClampToEdge
            sampler.rAddressMode = .ClampToEdge
            sampler.normalizedCoordinates = true
            sampler.lodMinClamp = 0
            sampler.lodMaxClamp = FLT_MAX
        }
        else {
            print("ERROR: Failed to create a sampler descriptor!")
        }
        return device.newSamplerStateWithDescriptor(samplerDescriptor!)
    }
}