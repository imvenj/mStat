//
//  ProgressBar.swift
//  mStat Widget
//
//  Created by venj on 2017/11/17.
//  Copyright © 2017年 venj. All rights reserved.
//

import Cocoa

/// A static progress bar which is easier to customize tint color without the
/// overhaul of a full-fledged animatable progress bar like the systom provided
/// one.

@IBDesignable
class ProgressBar: NSView {

    @IBInspectable var borderTintColor: NSColor = NSColor(red:0.75, green:0.75, blue:0.75, alpha:1.00) {
        didSet {
            needsDisplay = true
        }
    }
    @IBInspectable var backgroundTintColor: NSColor = NSColor(red:0.86, green:0.86, blue:0.86, alpha:1.00) {
        didSet {
            needsDisplay = true
        }
    }
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            needsDisplay = true
        }
    }
    @IBInspectable var thickness: CGFloat = 6.0 {
        didSet {
            needsDisplay = true
        }
    }
    @IBInspectable var tintColor: NSColor = NSColor(red:0.36, green:0.72, blue:0.36, alpha:1.00) {
        didSet {
            needsDisplay = true
        }
    }
    @IBInspectable var minimum: Double = 0.0 {
        didSet {
            needsDisplay = true
        }
    }
    @IBInspectable var maximum: Double = 100.0 {
        didSet {
            needsDisplay = true
        }
    }
    @IBInspectable var current: Double = 0.0 {
        didSet {
            needsDisplay = true
        }
    }
    
    override var fittingSize: NSSize {
        get {
            return NSSize(width: 20.0, height: thickness * borderWidth * 2.0)
        }
    }

    private var cornerRadius: CGFloat {
        get {
            return (thickness + borderWidth / 2.0) / 2.0
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSGraphicsContext.saveGraphicsState()
        drawProgressBar()
        NSGraphicsContext.restoreGraphicsState()
    }

    private func drawProgressBar() {
        let borderRect = NSMakeRect(borderWidth / 2.0, (bounds.size.height - thickness - borderWidth * 2.0) / 2.0 + borderWidth / 2.0, bounds.size.width - borderWidth, thickness + borderWidth)
        let borderPath = NSBezierPath(roundedRect: borderRect, xRadius: cornerRadius, yRadius: cornerRadius)
        borderPath.lineWidth = borderWidth

        borderTintColor.setStroke()
        borderPath.stroke()
        backgroundTintColor.setFill()
        borderPath.fill()

        if (current - minimum) != 0 {
            let progressPath = NSBezierPath()
            let startX = borderWidth + thickness / 2.0
            let startY = bounds.size.height / 2.0
            progressPath.move(to: NSPoint(x: startX, y: startY))
            var percentage = (current - minimum) / (maximum - minimum)
            if percentage > 1.0 { percentage = 1.0 } // Make sure progress bar will not longer than container
            let totalLineWidth = bounds.size.width - (borderWidth * 2 + thickness)
            progressPath.line(to: NSPoint(x: startX + totalLineWidth * CGFloat(percentage), y: startY))
            progressPath.lineWidth = thickness
            progressPath.lineCapStyle = .roundLineCapStyle
            tintColor.setStroke()
            progressPath.stroke()
        }
    }
}
