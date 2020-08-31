//
//  Avatar.swift
//  Kafka
//
//  Created by Ju on 23/07/2017.
//  Copyright © 2017 TroisYaourts. All rights reserved.
//

import Foundation
import SpriteKit


class Teleport:MonospaceSprite{
    
    public var number: Int = 0
    
    init(containerSize:CGSize){
        super.init(containerSize: containerSize, imageNamed: "teleport")
        zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
