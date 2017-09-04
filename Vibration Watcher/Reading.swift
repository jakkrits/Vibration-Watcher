//
//  Reading.swift
//  Vibration Watcher
//
//  Created by Jakk on 11/19/2559 BE.
//  Copyright © 2559 Jakk. All rights reserved.
//

import Foundation

struct Reading {
    let total: String
    let x: String
    let y: String
    let z: String
    let timestamp: String
    
    init(total: String, x: String, y: String, z: String, timestamp: String) {
        self.total = total
        self.x = x
        self.y = y
        self.z = z
        self.timestamp = timestamp
    }
}
