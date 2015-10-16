//
//  Input.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 9/6/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation

class Input {
    
    // TODO: Modify this to use keycodes, probably with an enum (and check if there are any OSX APIs that already do this)
    
    static var mouseX : Float = 0.0
    static var mouseY : Float = 0.0
    static var scrollX : Float = 0.0
    static var scrollY : Float = 0.0
    
    private static var keysDown = Set<Character>()
    private static var keys = Set<Character>()
    private static var keysUp = Set<Character>()
    
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
    
    static func setKeyDown(char: Character) {
        if !keysDown.contains(char) {
            keysDown.insert(char)
        }
        if !keys.contains(char) {
            keys.insert(char)
        }
        if keysUp.contains(char) {
            keysUp.remove(char)
        }
    }
    
    static func setKeyUp(char: Character) {
        if keysDown.contains(char) {
            keysDown.remove(char)
        }
        if keys.contains(char) {
            keys.remove(char)
        }
        if !keysUp.contains(char) {
            keysUp.insert(char)
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
    
    static func getKeyDown(char: Character) -> Bool {
        return keysDown.contains(char)
    }
    
    static func getKey(char: Character) -> Bool {
        return keys.contains(char)
    }
    
    static func getKeyUp(char: Character) -> Bool {
        return keysUp.contains(char)
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