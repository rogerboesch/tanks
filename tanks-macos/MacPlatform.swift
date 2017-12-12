//
//  MacPlatform.swift
//  Platform(s): macOS
//
//  Created by Roger Boesch on 04/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import AppKit
import SpriteKit

// Only typealias needed for color handling
public typealias UIColor = NSColor
public typealias UIImage = NSImage

// Window size on macOS version
let windowSize = CGSize.make(1024, 768)

// NSImage resize function used to simulate iOS UIGraphicsBeginImageContext
func resize(image: NSImage, w: Int, h: Int) -> NSImage {
    let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
    let newImage = NSImage(size: destSize)
    
    newImage.lockFocus()
    image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: .sourceOver, fraction: CGFloat(1))
    newImage.unlockFocus()
    newImage.size = destSize
    return NSImage(data: newImage.tiffRepresentation!)!
}
