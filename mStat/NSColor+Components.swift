//
//  NSColor+Components.swift
//  mStat
//
//  Created by venj on 2017/11/23.
//  Copyright © 2017年 venj. All rights reserved.
//

import Cocoa

public extension NSColor {
    public var components: [Double] {
        get {
            return [Double(redComponent), Double(greenComponent), Double(blueComponent), Double(alphaComponent)]
        }
    }
    
    public convenience init(components: [Double]) {
        var comp = components
        if components.count < 4 {
            for _ in components.count..<4 {
                comp.append(1.0)
            }
        }
        
        self.init(red: CGFloat(comp[0]), green: CGFloat(comp[1]), blue: CGFloat(comp[2]), alpha: CGFloat(comp[3]))
    }
}
