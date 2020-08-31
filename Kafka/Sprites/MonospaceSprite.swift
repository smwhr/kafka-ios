//
//  MonospaceSprite.swift
//  Kafka
//
//  Created by Ju on 24/07/2017.
//  Copyright © 2017 TroisYaourts. All rights reserved.
//

import Foundation
import SpriteKit


class MonospaceSprite:SKSpriteNode{
    private var spsize: CGSize = CGSize(width: 0, height: 0)
    public var traversable: Bool = false
    public var destroyable: Bool = true
    public var monospacePosition: Vector2D<Int> = Vector2D<Int>(x:0, y:0)
    
    init(containerSize:CGSize, imageNamed:String){
        
        spsize = CGSize(width:containerSize.width/33, height: containerSize.height/19)
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.blue, size: spsize)
    }
    
    func move(to position:Vector2D<Int>){
        self.position.x = CGFloat(position.x) * spsize.width + 0.5 * spsize.width
        self.position.y = CGFloat(position.y) * spsize.height + 0.5 * spsize.height
        
        monospacePosition.x = position.x
        monospacePosition.y = position.y
    }
    
    func move(x:Int, y:Int){
        self.move(to: Vector2D<Int>(x:x, y:y))
    }
    
    func isOn(sprite:MonospaceSprite) -> Bool{
        return monospacePosition.x == sprite.monospacePosition.x
            && monospacePosition.y == sprite.monospacePosition.y
    }
    
    func isOn(sprites: [MonospaceSprite]) -> MonospaceSprite?{
        for s in sprites {
            if isOn(sprite: s) {
             return s
            }
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
