//
//  RBLog.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 19/05/15.
//  Copyright © 2015 Roger Boesch. All rights reserved.
//

import Foundation
import SceneKit

enum RBLogSeverity : Int {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    case none = 4
}

public class RBLog: NSObject {
    static let debug = 0
    static let info = 1
    static let warning = 2
    static let error = 3
    static let none = 4
    
    static var _severity = RBLogSeverity.debug
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    static var severity: RBLogSeverity {
        get {
            return _severity
        }
        set(value) {
            _severity = value
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Logging severity
        
    static func error(message: String) {
        if (RBLogSeverity.error.rawValue >= RBLog.severity.rawValue) {
            RBLog.log(message: message, severity: "🔴")
        }
    }
    
    // -------------------------------------------------------------------------
    
    static func warning(message: String) {
        if (RBLogSeverity.warning.rawValue >= RBLog.severity.rawValue) {
            RBLog.log(message: message, severity: "⚠️")
        }
    }

    // -------------------------------------------------------------------------

    static func info(message: String) {
        if (RBLogSeverity.info.rawValue >= RBLog.severity.rawValue) {
            RBLog.log(message: message, severity: "ℹ️")
        }
    }
    
    // -------------------------------------------------------------------------
    
    static func debug(message: String) {
        if (RBLogSeverity.debug.rawValue >= RBLog.severity.rawValue) {
            RBLog.log(message: message, severity: "▷")
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Write logs
    
    private static func log(message: String, severity: String) {
        RBLog.write(message: "\(severity) \(message)")
    }
    
    // -------------------------------------------------------------------------
   
    static func write(message: String) {
        print(message)
    }
    
    // -------------------------------------------------------------------------

}

// -----------------------------------------------------------------------------
// MARK: - Short functions

func rbError(_ message: String,  _ args: CVarArg...) {
    let str = String(format: message, arguments: args)
    RBLog.error(message: str)
}

// -----------------------------------------------------------------------------

func rbWarning(_ message: String,  _ args: CVarArg...) {
    let str = String(format: message, arguments: args)
    RBLog.warning(message: str)
}

// -----------------------------------------------------------------------------

func rbInfo(_ message: String,  _ args: CVarArg...) {
    let str = String(format: message, arguments: args)
    RBLog.info(message: str)
}

// -----------------------------------------------------------------------------

func rbDebug(_ message: String,  _ args: CVarArg...) {
    let str = String(format: message, arguments: args)
    RBLog.debug(message: str)
}

// -----------------------------------------------------------------------------

func rbWrite(_ message: String,  _ args: CVarArg...) {
    let str = String(format: message, arguments: args)
    RBLog.write(message: str)
}

// -----------------------------------------------------------------------------
// MARK: - Log helpers

public func rbDebug(_ message: String, vector: SCNVector3) {
    rbDebug("\(message) x:\(vector.x) y:\(vector.y) z:\(vector.z)")
}

// -----------------------------------------------------------------------------

public func rbDebug(_ message: String, point: CGPoint) {
    rbDebug("\(message) x:\(Int(point.x)) y:\(Int(point.y))")
}

// -----------------------------------------------------------------------------

public func rbDebug(_ message: String, rect: CGRect) {
    rbDebug("\(message) x:\(Int(rect.origin.x)) y:\(Int(rect.origin.y)) width:\(Int(rect.size.width)) height:\(Int(rect.size.height))")
}

// -----------------------------------------------------------------------------

