//
//  Graphics.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 10/19/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation
import Metal
import MetalKit

// Class used largely for global variables/functions dealing with renderer state
// TODO: Needs a better name
class Graphics {
    var device : MTLDevice {
        get { return _device }
    }
    private var _device : MTLDevice
    
    var pipelineState : MTLRenderPipelineState?
    var depthStencilState : MTLDepthStencilState
    var commandQueue : MTLCommandQueue
    
    private var defaultLibrary : MTLLibrary
    private var defaultVert : MTLFunction
    private var defaultFrag : MTLFunction
    
    private var textureLoader : MTKTextureLoader
    
    var errorPinkTex : MTLTexture {
        get { return _errorPinkTex }
    }
    private var _errorPinkTex : MTLTexture
    
    init(mtkView: MTKView) {
        
        _device = MTLCreateSystemDefaultDevice()!
        mtkView.device = _device
        mtkView.depthStencilPixelFormat = .Depth32Float_Stencil8
        mtkView.sampleCount = 1
        
        print("MTKView set up using device \(_device.name!)")
        
        textureLoader = MTKTextureLoader(device: _device)
        let errorTexDesc = MTLTextureDescriptor()
        errorTexDesc.pixelFormat = .RGBA8Unorm
        _errorPinkTex = _device.newTextureWithDescriptor(errorTexDesc)
        _errorPinkTex.label = "Bright pink error texture"
        let bytes : [UInt8] = [255, 0, 255, 255]
        _errorPinkTex.replaceRegion(MTLRegionMake1D(0, 1), mipmapLevel: 0, withBytes: bytes, bytesPerRow: 4)
        
        defaultLibrary = _device.newDefaultLibrary()!
        defaultVert = defaultLibrary.newFunctionWithName("basicVert")!
        defaultFrag = defaultLibrary.newFunctionWithName("basicFrag")!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = defaultVert
        pipelineDescriptor.fragmentFunction = defaultFrag
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = mtkView.depthStencilPixelFormat
        pipelineDescriptor.stencilAttachmentPixelFormat = mtkView.depthStencilPixelFormat
        pipelineDescriptor.sampleCount = mtkView.sampleCount
        
        do {
            pipelineState = try _device.newRenderPipelineStateWithDescriptor(pipelineDescriptor)
        } catch {
            print("Failed to create pipeline state object.")
        }
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .LessEqual
        depthStencilState = _device.newDepthStencilStateWithDescriptor(depthStencilDescriptor)
        
        commandQueue = _device.newCommandQueue()
        commandQueue.label = "Main Command Queue"
    }
    
    func loadTexture(path: String, ext: String, createMips: Bool) -> MTLTexture? {
        if let url = NSBundle.mainBundle().URLForResource(path, withExtension: ext) {
            do {
                let texture = try textureLoader.newTextureWithContentsOfURL(url, options: [MTKTextureLoaderOptionAllocateMipmaps : createMips])
                
                if createMips {
                    generateMipMaps(texture, commandQueue: commandQueue, block: { (commandBuffer) -> Void in
                        //print("Mips generated")
                    })
                }
                return texture
            } catch {
                print("Failed to load texture at url \(url)")
                return nil
            }
        }
        else {
            print("Url for path \(path).\(ext) could not be created!")
            return nil
        }
    }
    
    func generateMipMaps(texture: MTLTexture, commandQueue: MTLCommandQueue, block: MTLCommandBufferHandler) {
        let commandBuffer = commandQueue.commandBuffer()
        commandBuffer.addCompletedHandler(block)
        let blitCommandEnc = commandBuffer.blitCommandEncoder()
        blitCommandEnc.generateMipmapsForTexture(texture)
        blitCommandEnc.endEncoding()
        
        commandBuffer.commit()
    }
}