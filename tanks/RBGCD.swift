//
//  RBGCD.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 01/01/16.
//  Copyright © 2016 Roger Boesch. All rights reserved.
//

import Foundation

// -----------------------------------------------------------------------------
// MARK: - NSTimer replacment

typealias RepeatClosure = () -> ()

public class Repeat {
    
    static func once(after timeInterval: TimeInterval, _ closure: @escaping RepeatClosure) {
        let when = DispatchTime.now() + timeInterval
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
        }
    }
    
}

// -----------------------------------------------------------------------------
// MARK: - Async shortcut

typealias AsynchronousClosure = () -> ()

public class Asynchronous {
    
    static func execute(_ closure: @escaping AsynchronousClosure) {
        DispatchQueue.global().async {
            closure()
        }
    }
    
}

// -----------------------------------------------------------------------------


