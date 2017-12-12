//
//  AppDelegate.swift
//  Platform(s): tvOS
//
//  Created by Roger Boesch on 24/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var _window: UIWindow?
    private var _viewController: GameViewController?
    
    // -------------------------------------------------------------------------
    // MARK: - App life cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _viewController = GameViewController()
        
        _window = UIWindow(frame: UIScreen.main.bounds)
        _window?.rootViewController = _viewController
        _window?.makeKeyAndVisible()
        
        return true
    }
    
    // -------------------------------------------------------------------------
    
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
    
    // -------------------------------------------------------------------------
    
}

