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
    
    var graphics : Graphics! = nil
    
    var whiteTex : MTLTexture?
    var colorAtlasTex : MTLTexture?
    var grid : Grid! = nil
    var axis : AxisMesh! = nil
    var objToDraw : Cube! = nil
    var viewMatrix : Mat4 = Mat4.identity()
    var projectionMatrix : Mat4 = Mat4()
    var axisProjMatrix : Mat4 = Mat4()
    var gridUniformBuffer : MTLBuffer! = nil
    var uniformBuffer : MTLBuffer! = nil
    var axisUniformBuffer : MTLBuffer! = nil
    var camPosition = Vector3(x: 0.0, y: 2.0, z: -6.0)
    var camRotation = Vector3()
    
    let moveSpeed : Float = 5.0
    let lookSensitivity : Float = 10.0
    
    var lastFrameTimestamp: CFTimeInterval = 0.0
    
    func resetProjectionMatrix() {
        projectionMatrix = Mat4.perspective(60.0, aspect: Float(view.bounds.width / view.bounds.height), nearZ: 0.1, farZ: 100.0)
        axisProjMatrix = Mat4.perspective(30.0, aspect: 1.0, nearZ: 0.05, farZ: 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view as! MTKView
        view.delegate = self
        
        // This lets us get all the mouse/keyboard input events you'd normally want in a game
        view.window?.makeFirstResponder(view)
        view.window?.acceptsMouseMovedEvents = true
        
        graphics = Graphics(mtkView: view)
        
        // May want to use this?
        //NSEvent.addLocalMonitorForEventsMatchingMask(.KeyDownMask, handler: nil)
        
        resetProjectionMatrix()
        
        whiteTex = graphics.loadTexture("white", ext: "png", createMips: false)
        colorAtlasTex = graphics.loadTexture("colorAtlas", ext: "png", createMips: false)
                
        gridUniformBuffer = graphics.device.newBufferWithLength(Mat4.bufferSize * 2, options: [])
        uniformBuffer = graphics.device.newBufferWithLength(Mat4.bufferSize * 2, options: [])
        
        grid = Grid(device: graphics.device, size: 10)
        
        axis = AxisMesh(device: graphics.device)
        axisUniformBuffer = graphics.device.newBufferWithLength(Mat4.bufferSize * 2, options: [])
        
        objToDraw = Cube(graphics: graphics)
        objToDraw.position = Vector3(x: 0.0, y: 0.5, z: 2.0)
        objToDraw.scale = Vector3(x: 2.0, y: 1.0, z: 1.0)
        
        lastFrameTimestamp = CACurrentMediaTime()
    }
    
    func render() {
        
        let view = self.view as! MTKView
        
        let commandBuffer = graphics.commandQueue.commandBuffer()
        commandBuffer.label = "Frame command buffer"
        
        // TODO: Separate some of this stuff out, in a sort of 'per-camera' way
        // TODO: Instead of using the view's descriptor, generate one in Graphics
        // Otherwise we're stuck to the same 'camera' settings for all drawing
        if let renderPassDesc = view.currentRenderPassDescriptor, drawable = view.currentDrawable {
            renderPassDesc.colorAttachments[0].loadAction = .Clear
            renderPassDesc.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            renderPassDesc.colorAttachments[0].storeAction = (view.sampleCount > 1 ? .MultisampleResolve : .Store)
            renderPassDesc.depthAttachment.loadAction = .Clear
            viewMatrix = Mat4.fpsView(camPosition, pitch: camRotation.x, yaw: camRotation.y)
            
            let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDesc)
            renderEncoder.label = "Render Encoder"
            
            renderEncoder.pushDebugGroup("Draw Objects")
            renderEncoder.setCullMode(.Back)
            renderEncoder.setRenderPipelineState(graphics.pipelineState!)
            renderEncoder.setDepthStencilState(graphics.depthStencilState)
            
            // First draw grid
            renderEncoder.setVertexBuffer(grid.vertexBuffer, offset: 0, atIndex: 0)
            if whiteTex != nil { renderEncoder.setFragmentTexture(whiteTex, atIndex: 0) }
            else { renderEncoder.setFragmentTexture(graphics.errorPinkTex, atIndex: 0) }
                
            // TODO: Set sampler state per-texture
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
            
            // Draw grid axis mesh
            let bufPointerAxis = axisUniformBuffer.contents()
            viewMatrix.setRow(3, vec3: Vector3(x: 0, y: 0, z: 4))
            memcpy(bufPointerAxis, viewMatrix.toBuffer(), Mat4.bufferSize)
            memcpy(bufPointerAxis + Mat4.bufferSize, axisProjMatrix.toBuffer(), Mat4.bufferSize)
            renderEncoder.setVertexBuffer(axisUniformBuffer, offset: 0, atIndex: 1)
            
            renderEncoder.setVertexBuffer(axis.mesh.vertexBuffers[0].buffer, offset: 0, atIndex: 0)
            renderEncoder.setFragmentTexture(colorAtlasTex, atIndex: 0)
            if let samplerState = objToDraw.samplerState {
                renderEncoder.setFragmentSamplerState(samplerState, atIndex: 0)
            }
            let scale = Double((view.window?.screen?.backingScaleFactor)!)
            let size = 90 * scale
            renderEncoder.setViewport(MTLViewport(originX: 10 * scale, originY: (Double(view.drawableSize.height) - size) - 10, width: size, height: size, znear: -1, zfar: 1))
            
            renderEncoder.drawIndexedPrimitives(MTLPrimitiveType.Triangle, indexCount: axis.mesh.submeshes[0].indexCount, indexType: axis.mesh.submeshes[0].indexType, indexBuffer: axis.mesh.submeshes[0].indexBuffer.buffer, indexBufferOffset: 0)

            
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
        if camRotation.y >= 360.0 { camRotation.y -= 360.0 }
        else if camRotation.y <= -360.0 { camRotation.y += 360.0 }
        
        var inputX : Float = 0.0
        var inputY : Float = 0.0
        
        if Input.getKey(KeyCode.A) { inputX -= 1.0 }
        if Input.getKey(KeyCode.D) { inputX += 1.0 }
        
        if Input.getKey(KeyCode.W) { inputY += 1.0 }
        if Input.getKey(KeyCode.S) { inputY -= 1.0 }
        
        let fwdMove = viewMatrix.getColumn(2) * inputY
        let sideMove = viewMatrix.getColumn(0) * inputX
        var moveDirection = (fwdMove + sideMove)
        if (moveDirection.sqrMagnitude() > 0.0) { moveDirection = moveDirection.normalized() }
        
        camPosition += moveDirection * (moveSpeed * delta)
        
        let zoom = viewMatrix.getColumn(2) * Input.scrollY * 0.05
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
