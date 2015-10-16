//
//  GameView.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 9/5/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation
import MetalKit

class GameView : MTKView {
    
    override func keyDown(theEvent: NSEvent) {
        if let chars = theEvent.charactersIgnoringModifiers {
            Input.setKeyDown(chars[chars.startIndex])
        }
    }
    
    override func keyUp(theEvent: NSEvent) {
        if let chars = theEvent.charactersIgnoringModifiers {
            Input.setKeyUp(chars[chars.startIndex])
        }
    }
    
    override func mouseDown(theEvent: NSEvent) {
        Input.setMouseButtonDown(theEvent.buttonNumber)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        Input.setMouseButtonUp(theEvent.buttonNumber)
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        Input.mouseX += Float(theEvent.deltaX)
        Input.mouseY -= Float(theEvent.deltaY)
    }
    
    override func rightMouseDown(theEvent: NSEvent) {
        Input.setMouseButtonDown(theEvent.buttonNumber)
    }
    
    override func rightMouseUp(theEvent: NSEvent) {
        Input.setMouseButtonUp(theEvent.buttonNumber)
    }
    
    override func rightMouseDragged(theEvent: NSEvent) {
        Input.mouseX += Float(theEvent.deltaX)
        Input.mouseY -= Float(theEvent.deltaY)
    }
    
    override func otherMouseDown(theEvent: NSEvent) {
        Input.setMouseButtonDown(theEvent.buttonNumber)
    }
    
    override func otherMouseUp(theEvent: NSEvent) {
        Input.setMouseButtonUp(theEvent.buttonNumber)
    }
    
    override func otherMouseDragged(theEvent: NSEvent) {
        Input.mouseX += Float(theEvent.deltaX)
        Input.mouseY -= Float(theEvent.deltaY)
    }
    
    override func mouseMoved(theEvent: NSEvent) {
        Input.mouseX += Float(theEvent.deltaX)
        Input.mouseY -= Float(theEvent.deltaY)
    }
    
    override func scrollWheel(theEvent: NSEvent) {
        Input.scrollX += Float(theEvent.scrollingDeltaX)
        Input.scrollY += Float(theEvent.scrollingDeltaY)
    }
}