//
//  Board.swift
//  Kafka
//
//  Created by Ju on 23/07/2017.
//  Copyright © 2017 TroisYaourts. All rights reserved.
//

import Foundation
import SpriteKit


class BoardScene: KafkaScene{
    // sprites
    private var player:Player!
    private var labyrinth:Array2D<MonospaceSprite>!
    private var teleports:Array<MonospaceSprite>!
    private var ennemies:Array<MonospaceSprite>!
    private var exit:MonospaceSprite!
    
    // score
    private var currentScore: Int = 0
    private var score: Int = 0
    private let scoreToWin: Int = 1000
    
    // internals
    var initialPlayerPosition:Vector2D<Int> = Vector2D<Int>(x: 1,y: 9)
    var exitPosition:Vector2D<Int> = Vector2D<Int>(x: 32,y: 9)
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.green
        
        player = Player(containerSize: size)
        score = 0
        
        initBoard()
        
    }
    
    override func initBoard(){
        randomInitBoard()
    }
    
    func randomInitBoard(){
        removeAllChildren()
        
        addChild(player)
        currentScore = 0
        
        player.move(to: initialPlayerPosition)
        labyrinth = createNewLabyrinth()
        
        teleports = createTeleports()
        ennemies = createEnnemies()
        
    }
    
    func createNewLabyrinth() -> Array2D<MonospaceSprite>{
        let labyrinth = Array2D<MonospaceSprite>(columns: 33, rows: 19)
        for x in 0...32{
            for y in 0...18 {
                labyrinth[x,y] = Empty(containerSize:size)
                
                if(x == exitPosition.x && y == exitPosition.y ){
                    labyrinth[x,y] = Exit(containerSize:size)
                    exit = labyrinth[x,y]
                }else if(x == player.monospacePosition.x && y == player.monospacePosition.y ){
                    labyrinth[x,y] = Empty(containerSize:size)
                }else if(x == 0 || x == 32 || y == 0 || y == 18){ // bordure
                    labyrinth[x,y] = Wall(containerSize:size)
                    labyrinth[x,y]?.destroyable = false
                }else if(x%2 == 0 && y%2 == 0){ // une case sur deux colorée
                    labyrinth[x,y] = Wall(containerSize:size)
                }else{
                    if((labyrinth[x-1, y-1] as? Wall) != nil){ // en bas à droite d'une pleine : une vide
                        labyrinth[x,y] = Empty(containerSize:size)
                    }
                    else{
                        if(random() < 0.333){ // 3/10 de mur sinon
                            labyrinth[x,y] = Wall(containerSize:size)
                        }else{
                            labyrinth[x,y] = Empty(containerSize:size)
                        }
                    }
                }
                
                labyrinth[x,y]?.move(x: x, y: y)
                addChild(labyrinth[x,y]!)
            }
        }
        
        return labyrinth
    }
    
    func createTeleports() -> Array<MonospaceSprite>{
        var teleports = Array<MonospaceSprite>()
        for i in 0...5{
            let teleport = Teleport(containerSize:size);
                teleport.number = i
            var tx = 0
            var ty = 0
            repeat{
                tx = Int(randomRange(min: 7, max: 27));
                ty = Int(randomRange(min: 3, max: 18));
            }while((labyrinth[tx,ty] as? Wall) != nil)
            
            teleport.move(x: tx, y: ty)
            teleports.append(teleport)
            addChild(teleport)
        }
        return teleports
    }
    
    func createEnnemies() -> Array<MonospaceSprite>{
        var ennemies = Array<MonospaceSprite>()
        for _ in 0...14{
            let ennemy = Ennemy(containerSize:size);
            var tx = 0
            var ty = 0
            repeat{
                tx = Int(randomRange(min: 25, max: 31));
                ty = Int(randomRange(min: 1, max: 18));
            }while(!(labyrinth[tx,ty]?.traversable)!)
            
            ennemy.move(x: tx, y: ty)
            ennemies.append(ennemy)
            addChild(ennemy)
        }
        return ennemies
    }
    
    func ennemy(at position:Vector2D<Int>) -> Bool{
        for e in ennemies{
            if e.monospacePosition.x == position.x && e.monospacePosition.y == position.y{
                return true
            }
        }
        return false
    }
    
    func player(at position:Vector2D<Int>) -> Bool{
        return player.monospacePosition.x == position.x && player.monospacePosition.y == position.y
    }
    
    func canMove(to position:Vector2D<Int>) -> Bool{
        if player.isOn(sprite: exit){
            return false
        }
        
        if (labyrinth[position.x, position.y]?.traversable)! {
            if !(ennemy(at: position)){
                if !(player(at: position)){
                        return true
                }
            }
        }
        return false
    }
    
    
    func movePlayer(direction:PlayerDirection) -> Bool{
        let futurePosition = player.monospacePosition.copy() as! Vector2D<Int>
        switch direction {
            case .up:
                futurePosition.y = futurePosition.y+1
                break
            case .down:
                futurePosition.y = futurePosition.y-1
                break
            case .left:
                futurePosition.x = futurePosition.x-1
                break
            case .right:
                futurePosition.x = futurePosition.x+1
                break
        
        }
        if canMove(to: futurePosition){
            player.move(to: futurePosition)
            currentScore += 1
            return true
        }
        return false
    }
    
    func renonce(){
        randomInitBoard()
        score = max(score - 100 + currentScore, 0)
        NotificationCenter.default.post(name: Notification.Name("score_change"), object: score)
    }
    
    func destroy(){
        for x in -1...1{
            for y in -1...1 {
                let dx = player.monospacePosition.x + x
                let dy = player.monospacePosition.y + y
                if(labyrinth[dx,dy]?.destroyable)!{
                    labyrinth[dx,dy]?.removeFromParent()
                    labyrinth[dx,dy] = Empty(containerSize: size)
                    labyrinth[dx,dy]?.move(x: dx, y: dy)
                    addChild(labyrinth[dx,dy]!)
                }
            }
        }
        score = max(score - currentScore, 0)
        NotificationCenter.default.post(name: Notification.Name("score_change"), object: score)
    }
    
    func moveEnnemies(){
        for e in ennemies{
            let dx = intsign(of: player.monospacePosition.x - e.monospacePosition.x)
            let dy = intsign(of: player.monospacePosition.y - e.monospacePosition.y)
            

            let destination = Vector2D<Int>(x: e.monospacePosition.x + dx, y: e.monospacePosition.y + dy)

            if canMove(to: destination){
                e.move(to: destination)
            }
            
        }
    }
    
    func turn(){
        // exit ?
        if player.isOn(sprite: exit){
            exitLevel()
            return
        }
        
        // teleport if player is on
        if let t = player.isOn(sprites: teleports) as? Teleport{
            let tDestination = teleports?[(t.number+1)%teleports.count]
            if((tDestination?.isOn(sprites: ennemies)) == nil){
                player.move(to: (tDestination?.monospacePosition)!)
            }
        }
        
        // move ennemies
        moveEnnemies()
        
    }
    
    func exitLevel(){
        score += 2*currentScore
        NotificationCenter.default.post(name: Notification.Name("score_change"), object: score)
        
        if(score >= scoreToWin){
            NotificationCenter.default.post(name: Notification.Name("win"), object: score)
            return
        }else{
            randomInitBoard()
        }
        
    }
}
