//
//  RB+CGRect.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 01/01/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
#endif

// -----------------------------------------------------------------------------
// MARK: - Replace width support

extension CGRect {
    func replaceWidth(_ width: CGFloat) -> CGRect {
        var rect = self
        rect.size.width = width
        
        return rect
    }
}

// -----------------------------------------------------------------------------
// MARK: - Make a CGRect

extension CGRect {
    
    static func make(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    func position(_ x: CGFloat, _ y: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: self.size.width, height: self.size.height)
    }
    
    func moveDown(_ offset: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.x+offset, width: self.size.width, height: self.size.height)
    }

}

// -----------------------------------------------------------------------------
