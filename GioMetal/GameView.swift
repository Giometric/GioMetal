//
//  GameView.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 9/5/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation
import MetalKit
import Carbon

class GameView : MTKView {
    
    // OS X doesn't send key up or down events for modifier keys
    // But the flags do tell you whether they're currently down
    // So do this dumb rigamarole to determine whether one was just pressed or released
    override func flagsChanged(theEvent: NSEvent) {
        
        let code = Int(theEvent.keyCode)
        
        if Int(code) == kVK_Shift && theEvent.modifierFlags.contains(.ShiftKeyMask) {
            Input.setKeyDown(KeyCode.LeftShift)
        }
        else if Int(code) == kVK_Shift {
            Input.setKeyUp(KeyCode.LeftShift)
        }
        
        if Int(code) == kVK_RightShift && theEvent.modifierFlags.contains(.ShiftKeyMask) {
            Input.setKeyDown(KeyCode.RightShift)
        }
        else if Int(code) == kVK_RightShift {
            Input.setKeyUp(KeyCode.RightShift)
        }
        
        if Int(code) == kVK_Control && theEvent.modifierFlags.contains(.ControlKeyMask) {
            Input.setKeyDown(KeyCode.RightShift)
        }
        else if Int(code) == kVK_Control {
            Input.setKeyUp(KeyCode.RightShift)
        }
        
        if Int(code) == kVK_RightControl && theEvent.modifierFlags.contains(.ControlKeyMask) {
            Input.setKeyDown(KeyCode.LeftControl)
        }
        else if Int(code) == kVK_RightControl {
            Input.setKeyUp(KeyCode.LeftControl)
        }
        
        if Int(code) == kVK_Option && theEvent.modifierFlags.contains(.AlternateKeyMask) {
            Input.setKeyDown(KeyCode.LeftAlt)
        }
        else if Int(code) == kVK_Option {
            Input.setKeyUp(KeyCode.LeftAlt)
        }
        
        if Int(code) == kVK_RightOption && theEvent.modifierFlags.contains(.AlternateKeyMask) {
            Input.setKeyDown(KeyCode.RightAlt)
        }
        else if Int(code) == kVK_RightOption {
            Input.setKeyUp(KeyCode.RightAlt)
        }
        
        if Int(code) == kVK_Command && theEvent.modifierFlags.contains(.CommandKeyMask) {
            Input.setKeyDown(KeyCode.Command)
        }
        else if Int(code) == kVK_Command {
            Input.setKeyUp(KeyCode.Command)
        }
        
        if Int(code) == kVK_Function && theEvent.modifierFlags.contains(.FunctionKeyMask) {
            Input.setKeyDown(KeyCode.Function)
        }
        else if Int(code) == kVK_Function {
            Input.setKeyUp(KeyCode.Function)
        }
    }
    
    override func keyDown(theEvent: NSEvent) {
        if let keyCode = KeyCode(rawValue: theEvent.keyCode) {
            Input.setKeyDown(keyCode)
        }
    }
    
    override func keyUp(theEvent: NSEvent) {
        if let keyCode = KeyCode(rawValue: theEvent.keyCode) {
            Input.setKeyUp(keyCode)
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