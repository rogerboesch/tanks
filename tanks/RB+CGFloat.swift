//
//  RB+CGFloat.swift
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
// MARK: - Radians/Degress conversion

extension CGFloat {
    
    func toDegrees() -> CGFloat {
        return self * 180.0 / CGFloat(Double.pi)
    }
    
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }

}

// -----------------------------------------------------------------------------
