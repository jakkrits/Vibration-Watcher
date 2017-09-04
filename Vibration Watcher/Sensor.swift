//
//  Sensor.swift
//  Vibration Watcher
//
//  Created by Jakk Sut on 11/7/2559 BE.
//  Copyright © 2559 Jakk. All rights reserved.
//

import Foundation

struct Sensor {
    let keyName: String
    let location: String
    let owner: String
    let ref: FIRDatabaseReference?

    init(keyName: String, location: String, owner: String) {
        self.keyName = keyName
        self.location = location
        self.owner = owner
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        keyName = snapshot.key
        location = "Sensor Location: Building 31 NRRU"
        owner = "Owner: Jakkrit"
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "keyName": keyName,
            "location": location,
            "owner": owner,
            "ref": ref as Any
        ]
    }
}
