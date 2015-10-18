//
//  Input.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 9/6/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation

class Input {
    
    // Input class based loosely on the basic parts of the Input system in Unity3D
    
    static var mouseX : Float = 0.0
    static var mouseY : Float = 0.0
    static var scrollX : Float = 0.0
    static var scrollY : Float = 0.0
    
    private static var keysDown = Set<KeyCode>()
    private static var keys = Set<KeyCode>()
    private static var keysUp = Set<KeyCode>()
    
    private static var mouseButtonsDown = Set<Int>()
    private static var mouseButtons = Set<Int>()
    private static var mouseButtonsUp = Set<Int>()
    
    // Call this to 'clear' any input that should only last for one frame
    static func endOfFrame() {
        keysDown.removeAll()
        keysUp.removeAll()
        mouseButtonsDown.removeAll()
        mouseButtonsUp.removeAll()
        
        mouseX = 0.0
        mouseY = 0.0
        scrollX = 0.0
        scrollY = 0.0
    }
    
    static func setKeyDown(key: KeyCode) {
        print("Key Down: \(key)")
        
        if !keysDown.contains(key) {
            keysDown.insert(key)
        }
        if !keys.contains(key) {
            keys.insert(key)
        }
        if keysUp.contains(key) {
            keysUp.remove(key)
        }
    }
    
    static func setKeyUp(key: KeyCode) {
        print("Key Up: \(key)")
        
        if keysDown.contains(key) {
            keysDown.remove(key)
        }
        if keys.contains(key) {
            keys.remove(key)
        }
        if !keysUp.contains(key) {
            keysUp.insert(key)
        }
    }
    
    static func setMouseButtonDown(button: Int) {
        if !mouseButtonsDown.contains(button) {
            mouseButtonsDown.insert(button)
        }
        if !mouseButtons.contains(button) {
            mouseButtons.insert(button)
        }
        if mouseButtonsUp.contains(button) {
            mouseButtonsUp.remove(button)
        }
    }
    
    static func setMouseButtonUp(button: Int) {
        if mouseButtonsDown.contains(button) {
            mouseButtonsDown.remove(button)
        }
        if mouseButtons.contains(button) {
            mouseButtons.remove(button)
        }
        if !mouseButtonsUp.contains(button) {
            mouseButtonsUp.insert(button)
        }
    }
    
    static func getKeyDown(key: KeyCode) -> Bool {
        return keysDown.contains(key)
    }
    
    static func getKey(key: KeyCode) -> Bool {
        return keys.contains(key)
    }
    
    static func getKeyUp(key: KeyCode) -> Bool {
        return keysUp.contains(key)
    }
    
    static func getMouseButtonDown(button: Int) -> Bool {
        return mouseButtonsDown.contains(button)
    }
    
    static func getMouseButton(button: Int) -> Bool {
        return mouseButtons.contains(button)
    }
    
    static func getMouseButtonUp(button: Int) -> Bool {
        return mouseButtonsUp.contains(button)
    }
}