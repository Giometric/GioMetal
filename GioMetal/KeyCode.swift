//
//  KeyCode.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 10/18/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation

// TODO: Not sure if there's any point, but would be nice if it was platform-agnostic?
// Might be better for them to be their own values with a "FromOSXKeyCode" function
enum KeyCode: UInt16 {
    
    // MARK: ANSI Key Codes, including modifier keys
    // The values match Apple's ANSI key codes defined in Carbon/HIToolbox/Events.h
    case A              = 0x00
    case B              = 0x0B
    case C              = 0x08
    case D              = 0x02
    case E              = 0x0E
    case F              = 0x03
    case G              = 0x05
    case H              = 0x04
    case I              = 0x22
    case J              = 0x26
    case K              = 0x28
    case L              = 0x25
    case M              = 0x2E
    case N              = 0x2D
    case O              = 0x1F
    case P              = 0x23
    case Q              = 0x0C
    case R              = 0x0F
    case S              = 0x01
    case T              = 0x11
    case U              = 0x20
    case V              = 0x09
    case W              = 0x0D
    case X              = 0x07
    case Y              = 0x10
    case Z              = 0x06
    
    case Alpha1         = 0x12
    case Alpha2         = 0x13
    case Alpha3         = 0x14
    case Alpha4         = 0x15
    case Alpha5         = 0x17
    case Alpha6         = 0x16
    case Alpha7         = 0x1A
    case Alpha8         = 0x1C
    case Alpha9         = 0x19
    case Alpha0         = 0x1D
    
    case Grave          = 0x32
    case Minus          = 0x1B
    case Equals         = 0x18
    case LeftBracket    = 0x21
    case RightBracket   = 0x1E
    case Backslash      = 0x2A
    case Semicolon      = 0x29
    case Quote          = 0x27
    case Comma          = 0x2B
    case Period         = 0x2F
    case Slash          = 0x2C
    
    case NumpadDecimal  = 0x41
    case NumpadMultiply = 0x43
    case NumpadPlus     = 0x45
    case NumpadClear    = 0x47
    case NumpadDivide   = 0x4B
    case NumpadEnter    = 0x4C
    case NumpadMinus    = 0x4E
    case NumpadEquals   = 0x51
    case Numpad0        = 0x52
    case Numpad1        = 0x53
    case Numpad2        = 0x54
    case Numpad3        = 0x55
    case Numpad4        = 0x56
    case Numpad5        = 0x57
    case Numpad6        = 0x58
    case Numpad7        = 0x59
    case Numpad8        = 0x5B
    case Numpad9        = 0x5C
    
    case Return         = 0x24
    case Tab            = 0x30
    case Space          = 0x31
    case Backspace      = 0x33
    case Escape         = 0x35
    case LeftShift      = 0x38
    case RightShift     = 0x3C
    case CapsLock       = 0x39
    case Function       = 0x3F
    case LeftControl    = 0x3B
    case RightControl   = 0x3E
    case LeftAlt        = 0x3A
    case RightAlt       = 0x3D
    case Command        = 0x37
    case Delete         = 0x75
    case Home           = 0x73
    case End            = 0x77
    case PageUp         = 0x74
    case PageDown       = 0x79
    case LeftArrow      = 0x7B
    case RightArrow     = 0x7C
    case DownArrow      = 0x7D
    case UpArrow        = 0x7E
    
    case F1             = 0x7A
    case F2             = 0x78
    case F3             = 0x63
    case F4             = 0x76
    case F5             = 0x60
    case F6             = 0x61
    case F7             = 0x62
    case F8             = 0x64
    case F9             = 0x65
    case F10            = 0x6D
    case F11            = 0x67
    case F12            = 0x6F
}