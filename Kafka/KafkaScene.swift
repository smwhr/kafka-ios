//
//  KafkaScene.swift
//  Kafka
//
//  Created by Ju on 24/07/2017.
//  Copyright © 2017 TroisYaourts. All rights reserved.
//

import Foundation
import SpriteKit

enum PlayerDirection: String, CustomStringConvertible {
    case up = "up", down = "down", left = "left", right = "right"
    
    var description: String {
        return self.rawValue
    }
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
}

func randomRange(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func intsign(of x:Int) -> Int {
    if(x == 0){
        return 0
    }
    return (x < 0 ? -1 : 1)
}

class KafkaScene: SKScene{
    
    func initBoard(){
    }
}
