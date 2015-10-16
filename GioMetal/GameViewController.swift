//
//  GameViewController.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 9/3/15.
//  Copyright (c) 2015 Giovanni Sabella. All rights reserved.
//

import Cocoa
import MetalKit

class GameViewController: NSViewController, MTKViewDelegate {
    
    let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    var pipelineState : MTLRenderPipelineState! = nil
    var commandQueue : MTLCommandQueue! = nil
    
    var whiteTex : MTLTexture!
    var grid : Grid!
    var objToDraw : Cube!
    var viewMatrix : Mat4 = Mat4.identity()
    var projectionMatrix : Mat4 = Mat4()
    var gridUniformBuffer : MTLBuffer! = nil
    var uniformBuffer : MTLBuffer! = nil
    var camPosition = Vector3(x: 0.0, y: 2.0, z: -6.0)
    var camRotation = Vector3()
    
    let moveSpeed : Float = 5.0
    let lookSensitivity : Float = 10.0
    
    var lastFrameTimestamp: CFTimeInterval = 0.0
    
    func resetProjectionMatrix() {
        projectionMatrix = Mat4.perspective(60.0, aspect: Float(view.bounds.width / view.bounds.height), nearZ: 0.1, farZ: 100.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! MTKView
        view.delegate = self
        view.device = device
        view.sampleCount = 1
        print("MTKView set up using device \(device.name!)")
        
        // This lets us get all the mouse/keyboard input events you'd normally want in a game
        view.window?.makeFirstResponder(view)
        view.window?.acceptsMouseMovedEvents = true
        
        // May want to use this?
        //NSEvent.addLocalMonitorForEventsMatchingMask(.KeyDownMask, handler: nil)
        
        commandQueue = device.newCommandQueue()
        commandQueue.label = "Main Command Queue"
        
        resetProjectionMatrix()
        
        let defaultLibrary = device.newDefaultLibrary()!
        let vertexProgram = defaultLibrary.newFunctionWithName("basicVert")!
        let fragmentProgram = defaultLibrary.newFunctionWithName("basicFrag")!
        
        let whiteTexUrl = NSBundle.mainBundle().URLForResource("white", withExtension: "png")
        let texLoader = MTKTextureLoader(device: device)
        
        do {
            whiteTex = try texLoader.newTextureWithContentsOfURL(whiteTexUrl!, options: [MTKTextureLoaderOptionAllocateMipmaps : false])
        } catch {
            print("Failed to load white texture.")
        }
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexProgram
        pipelineDescriptor.fragmentFunction = fragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        pipelineDescriptor.sampleCount = view.sampleCount
        
        do {
            pipelineState = try device.newRenderPipelineStateWithDescriptor(pipelineDescriptor)
        } catch {
            print("Failed to create pipeline state object.")
        }
        
        gridUniformBuffer = device.newBufferWithLength(Mat4.bufferSize * 2, options: [])
        uniformBuffer = device.newBufferWithLength(Mat4.bufferSize * 2, options: [])
        
        grid = Grid(device: device, size: 5)
        
        objToDraw = Cube(device: device, commandQueue: commandQueue)
        objToDraw.position = Vector3(x: 0.0, y: 0.5, z: 2.0)
        objToDraw.scale = Vector3(x: 2.0, y: 1.0, z: 1.0)
        
        lastFrameTimestamp = CACurrentMediaTime()
    }
    
    func render() {
        
        let view = self.view as! MTKView
        
        let commandBuffer = commandQueue.commandBuffer()
        commandBuffer.label = "Frame command buffer"
        
        if let renderPassDesc = view.currentRenderPassDescriptor, drawable = view.currentDrawable {
            renderPassDesc.colorAttachments[0].loadAction = .Clear
            renderPassDesc.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            renderPassDesc.colorAttachments[0].storeAction = (view.sampleCount > 1 ? .MultisampleResolve : .Store)
            
            viewMatrix = Mat4.lookAt(camPosition, target: Vector3(), up: Vector3.up)
            
            let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDesc)
            renderEncoder.label = "Render Encoder"
            
            renderEncoder.pushDebugGroup("Draw Objects")
            renderEncoder.setFrontFacingWinding(.CounterClockwise)
            renderEncoder.setCullMode(.Back)
            renderEncoder.setRenderPipelineState(pipelineState)
            
            // First draw grid
            renderEncoder.setVertexBuffer(grid.vertexBuffer, offset: 0, atIndex: 0)
            renderEncoder.setFragmentTexture(whiteTex, atIndex: 0)
            if let samplerState = objToDraw.samplerState {
                renderEncoder.setFragmentSamplerState(samplerState, atIndex: 0)
            }
            
            let bufferPointerGrid = gridUniformBuffer.contents()
            memcpy(bufferPointerGrid, viewMatrix.toBuffer(), Mat4.bufferSize)
            memcpy(bufferPointerGrid + Mat4.bufferSize, projectionMatrix.toBuffer(), Mat4.bufferSize)
            renderEncoder.setVertexBuffer(gridUniformBuffer, offset: 0, atIndex: 1)
            
            renderEncoder.drawPrimitives(.Line, vertexStart: 0, vertexCount: grid.vertexCount)
            
            // For all objects to be drawn
            renderEncoder.setVertexBuffer(objToDraw.vertexBuffer, offset: 0, atIndex: 0)
            renderEncoder.setFragmentTexture(objToDraw.texture, atIndex: 0)
            if let samplerState = objToDraw.samplerState {
                renderEncoder.setFragmentSamplerState(samplerState, atIndex: 0)
            }
            
            let mv = objToDraw.modelMatrix() * viewMatrix
            let bufferPointer = uniformBuffer.contents()
            memcpy(bufferPointer, mv.toBuffer(), Mat4.bufferSize)
            memcpy(bufferPointer + Mat4.bufferSize, projectionMatrix.toBuffer(), Mat4.bufferSize)
            renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, atIndex: 1)
            
            renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: objToDraw.vertexCount)
            // End objects loop
            
            renderEncoder.popDebugGroup()
            renderEncoder.endEncoding()
            
            commandBuffer.presentDrawable(drawable)
        }
        commandBuffer.commit()
    }
    
    func update(delta: Float) {
        objToDraw.update(delta)
        
        // Handle input for camera
        camRotation.x -= Input.mouseY * delta * lookSensitivity
        if camRotation.x > 90.0 { camRotation.x = 90.0 }
        else if camRotation.x < -90.0 { camRotation.x = -90.0 }
        
        camRotation.y += Input.mouseX * delta * lookSensitivity
        if camRotation.y >= 360.0 { camRotation.x -= 360.0 }
        else if camRotation.y < -360.0 { camRotation.x += 360.0 }
        
        var inputX : Float = 0.0
        var inputY : Float = 0.0
        
        if Input.getKey("a") { inputX -= 1.0 }
        if Input.getKey("d") { inputX += 1.0 }
        
        if Input.getKey("w") { inputY += 1.0 }
        if Input.getKey("s") { inputY -= 1.0 }
        
        // Has some problems if you try to loop around, but mostly works
        let upMove = viewMatrix.getColumn(1) * inputY
        let sideMove = viewMatrix.getColumn(0) * inputX
        var moveDirection = (upMove + sideMove)
        if (moveDirection.sqrMagnitude() > 0.0) { moveDirection = moveDirection.normalized() }
        
        camPosition += moveDirection * (moveSpeed * delta)
        
        let zoom = viewMatrix.getColumn(2) * Input.scrollY
        camPosition += zoom
        
        Input.endOfFrame()
    }
    
    func drawInMTKView(view: MTKView) {
        let currentTime = CACurrentMediaTime()
        let delta = currentTime - lastFrameTimestamp
        update(Float(delta))
        
        render()
        lastFrameTimestamp = currentTime
    }
    
    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        // Aspect ratio may have changed, re-create projection matrix
        resetProjectionMatrix()
    }
}
