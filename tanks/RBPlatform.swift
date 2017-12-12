//
//  RBPlatform.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 12.12.17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation

#if os(macOS)

    import AppKit

    public typealias RBImage = NSImage

    extension NSImage {
        class func getImage(named name: String) -> NSImage? {
            return NSImage(named: NSImage.Name(name))
        }
    }
    
#else

    import UIKit

    public typealias RBImage = UIImage

    extension UIImage {
        class func getImage(named name: String) -> UIImage? {
            return UIImage(named: name)
        }
    }
    
#endif

