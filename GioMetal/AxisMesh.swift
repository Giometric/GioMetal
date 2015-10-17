//
//  AxisMesh.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 10/16/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation
import ModelIO
import MetalKit

class AxisMesh {
    
    var mesh: MTKMesh! = nil
    
    init(device: MTLDevice) {
        
        let mtkAllocator = MTKMeshBufferAllocator(device: device)
        let vertDesc = MDLVertexDescriptor()
        
        // Must set the vertex buffer layout on the descriptor
        // Otherwise the descriptor will be competely ignored and the mesh will be loaded with whatever ModelIO finds
        let vertLayout = MDLVertexBufferLayout()
        vertLayout.stride = 36
        vertDesc.layouts[0] = vertLayout
        
        vertDesc.addOrReplaceAttribute(MDLVertexAttribute(name: MDLVertexAttributePosition, format: .Float3, offset: 0, bufferIndex: 0))
        vertDesc.addOrReplaceAttribute(MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate, format: .Float2, offset: 12, bufferIndex: 0))
        vertDesc.addOrReplaceAttribute(MDLVertexAttribute(name: MDLVertexAttributeColor, format: .Float4, offset: 20, bufferIndex: 0))
        let meshAsset = MDLAsset(URL: NSBundle.mainBundle().URLForResource("axis", withExtension: "obj")!, vertexDescriptor: vertDesc, bufferAllocator: mtkAllocator)
        if (meshAsset.count > 0)
        {
            if let mdlMesh : MDLMesh = meshAsset[0] as? MDLMesh {
                do {
                    try mesh = MTKMesh(mesh: mdlMesh, device: device)
                    
                    // Since OBJs cannot (normally) have color data, all the colors will be 0
                    // Currently we use a shader that multiplies vertex colors, so replace all the colors with 1
                    let colArray : [Float] = [1.0, 1.0, 1.0, 1.0]
                    let bufferPointer = mesh.vertexBuffers[0].buffer.contents()
                    for i in 0..<mesh.vertexCount {
                        memcpy(bufferPointer + (i * 36) + 20, colArray, 16)
                    }
                } catch {
                    print("Failed to create MTKMesh from MDLMesh! \(error)")
                }
            }
        }
    }
}