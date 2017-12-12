//
//  WindowController.swift
//  Platform(s): macOS
//
//  Created by Roger Boesch on 25/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import AppKit

class WindowController : NSWindowController {
    
    // -------------------------------------------------------------------------
    // MARK: - Touchbar Support
    
    @IBAction func touchFire(sender: Any) {
        rbDebug("Fire key pressed on TouchBar")
    }

    // -------------------------------------------------------------------------

}
