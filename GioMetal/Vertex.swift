//
//  Vertex.swift
//  GioMetal
//
//  Created by Giovanni Sabella on 9/3/15.
//  Copyright © 2015 Giovanni Sabella. All rights reserved.
//

import Foundation
// Not very versatile, will be reworked into a system using MTKMesh

struct Vertex {
    
    var x, y, z : Float
    var s, t : Float
    var r, g, b, a : Float
    
    func buffer() -> [Float] {
        return [x, y, z, s, t, r, g, b, a]
    }
}