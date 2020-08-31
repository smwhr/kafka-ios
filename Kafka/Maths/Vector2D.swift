//
//  Vector2D.swift
//  Kafka
//
//  Created by Ju on 23/07/2017.
//  Copyright © 2017 TroisYaourts. All rights reserved.
//

import Foundation

class Vector2D<T>:NSCopying {
    
    var x: T
    var y: T
    
    
    init(x: T, y: T) {
        self.x = x
        self.y = y
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Vector2D<T>(x: x, y: y)
        return copy
    }
}
