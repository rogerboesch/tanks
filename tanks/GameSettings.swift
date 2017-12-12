//
//  GameSettings.swift
//  Platform(s): iOS, tvOS, macOS
//
//  Created by Roger Boesch on 23/03/17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation

struct Game {
    
    // Weapon arsenal
    struct Weapon {
        public static let initialRockets: Int = 3
        public static let initialBullets: Int = 50
        public static let bulletsForTank: Int = 1
        
    }
    
    // Player health
    struct Health {
        public static let initial: Int = 100
        
        public static let hitByTank: Int = -50
        public static let hitByBullet: Int = -34
        public static let hitByRocket: Int = -34
        public static let shootARocket: Int = -10
        public static let shootABullet: Int = -1
        
        public static let destroyTank: Int = 36
    }
    
    // Player score
    struct Score {
        public static let destroyTank: Int = 100
        public static let remainingBullet: Int = 3
        public static let remainingRocket: Int = 10
    }

}
