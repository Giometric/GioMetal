//
//  GioMetalApplication.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 10/18/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation
import Cocoa

@objc(GioMetalApplication)
class GioMetalApplication: NSApplication {
    
    // KeyUp events are not sent if Command key is held down
    // To fix this we create our own subclass of NSApplication
    // The overridden sendEvent function checks for that particular case and sends the event out
    
    override func sendEvent(theEvent: NSEvent) {
        if theEvent.type == NSEventType.KeyUp && theEvent.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask) {
            Swift.print("BARF")
            self.keyWindow?.sendEvent(theEvent)
        }
        else {
            super.sendEvent(theEvent)
        }
    }
}