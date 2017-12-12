//
//  RB+CGPoint.swift
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
// MARK: - Make a CGPoint

extension CGPoint {
    static func make(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}

// -----------------------------------------------------------------------------
