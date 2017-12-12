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
        return self * 180.0 / CGFloat(M_PI)
    }
    
    func toRadians() -> CGFloat {
        return self * CGFloat(M_PI) / 180.0
    }

}

// -----------------------------------------------------------------------------
