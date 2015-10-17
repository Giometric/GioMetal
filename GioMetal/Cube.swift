//
//  Cube.swift
//  HelloMetal
//
//  Created by Giovanni Sabella on 8/31/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation
import Cocoa
import MetalKit

class Cube: Node {
    
    init (device: MTLDevice, commandQueue: MTLCommandQueue) {
        
        // Front
        let A = Vertex(x:  0.5, y:  0.5, z:  0.5, s:  0.0, t:  1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        let B = Vertex(x:  0.5, y: -0.5, z:  0.5, s:  0.0, t:  0.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        let C = Vertex(x: -0.5, y: -0.5, z:  0.5, s:  1.0, t:  0.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        let D = Vertex(x: -0.5, y:  0.5, z:  0.5, s:  1.0, t:  1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        
        // Back
        let E = Vertex(x: -0.5, y:  0.5, z: -0.5, s:  0.0, t:  1.0, r:  1.0, g:  0.0, b:  1.0, a:  1.0)
        let F = Vertex(x: -0.5, y: -0.5, z: -0.5, s:  0.0, t:  0.0, r:  1.0, g:  0.0, b:  1.0, a:  1.0)
        let G = Vertex(x:  0.5, y: -0.5, z: -0.5, s:  1.0, t:  0.0, r:  1.0, g:  0.0, b:  1.0, a:  1.0)
        let H = Vertex(x:  0.5, y:  0.5, z: -0.5, s:  1.0, t:  1.0, r:  1.0, g:  0.0, b:  1.0, a:  1.0)
        
        // Left
        let I = Vertex(x: -0.5, y:  0.5, z:  0.5, s:  0.0, t:  1.0, r:  1.0, g:  1.0, b:  0.0, a:  1.0)
        let J = Vertex(x: -0.5, y: -0.5, z:  0.5, s:  0.0, t:  0.0, r:  1.0, g:  1.0, b:  0.0, a:  1.0)
        let K = Vertex(x: -0.5, y: -0.5, z: -0.5, s:  1.0, t:  0.0, r:  1.0, g:  1.0, b:  0.0, a:  1.0)
        let L = Vertex(x: -0.5, y:  0.5, z: -0.5, s:  1.0, t:  1.0, r:  1.0, g:  1.0, b:  0.0, a:  1.0)
        
        // Right
        let M = Vertex(x:  0.5, y:  0.5, z: -0.5, s:  0.0, t:  1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let N = Vertex(x:  0.5, y: -0.5, z: -0.5, s:  0.0, t:  0.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let O = Vertex(x:  0.5, y: -0.5, z:  0.5, s:  1.0, t:  0.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let P = Vertex(x:  0.5, y:  0.5, z:  0.5, s:  1.0, t:  1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        
        // Top
        let Q = Vertex(x: -0.5, y:  0.5, z:  0.5, s:  0.0, t:  1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let R = Vertex(x: -0.5, y:  0.5, z: -0.5, s:  0.0, t:  0.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let S = Vertex(x:  0.5, y:  0.5, z: -0.5, s:  1.0, t:  0.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let T = Vertex(x:  0.5, y:  0.5, z:  0.5, s:  1.0, t:  1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        
        // Bottom
        let U = Vertex(x: -0.5, y: -0.5, z: -0.5, s:  0.0, t:  1.0, r:  0.0, g:  1.0, b:  1.0, a:  1.0)
        let V = Vertex(x: -0.5, y: -0.5, z:  0.5, s:  0.0, t:  0.0, r:  0.0, g:  1.0, b:  1.0, a:  1.0)
        let W = Vertex(x:  0.5, y: -0.5, z:  0.5, s:  1.0, t:  0.0, r:  0.0, g:  1.0, b:  1.0, a:  1.0)
        let X = Vertex(x:  0.5, y: -0.5, z: -0.5, s:  1.0, t:  1.0, r:  0.0, g:  1.0, b:  1.0, a:  1.0)
        
        let vertices = [
            A,C,B ,A,D,C,   //Front
            E,G,F ,E,H,G,   //Back
            
            I,K,J ,I,L,K,   //Left
            M,O,N ,M,P,O,   //Right
            
            Q,S,R ,Q,T,S,   //Top
            U,W,V ,U,X,W    //Bot
        ]
        
        let texUrl = NSBundle.mainBundle().URLForResource("testBox", withExtension: "png")
        let texLoader = MTKTextureLoader(device: device)
        var texture : MTLTexture? = nil
        
        do {
            texture = try texLoader.newTextureWithContentsOfURL(texUrl!, options: [MTKTextureLoaderOptionAllocateMipmaps : true])
            Cube.generateMipMaps(texture!, commandQueue: commandQueue, block: { (buffer) -> Void in
                print("Mips generated")
                })
        } catch {
            print("Failed to load texture.")
        }
        
        super.init(name: "Cube", vertices: vertices, device: device, texture: texture!)
    }
    
    class func generateMipMaps(texture: MTLTexture, commandQueue: MTLCommandQueue, block: MTLCommandBufferHandler) {
        
        let commandBuffer = commandQueue.commandBuffer()
        commandBuffer.addCompletedHandler(block)
        let blitCommandEnc = commandBuffer.blitCommandEncoder()
        blitCommandEnc.generateMipmapsForTexture(texture)
        blitCommandEnc.endEncoding()
        
        commandBuffer.commit()
    }
}

