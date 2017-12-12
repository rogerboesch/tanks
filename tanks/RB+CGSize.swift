//
//  RB+CGSize.swift
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
// MARK: - Make a CGSize

extension CGSize {
    
    static func make(_ w: CGFloat, _ h: CGFloat) -> CGSize {
        return CGSize(width: w, height: h)
    }
    
}

// -----------------------------------------------------------------------------
