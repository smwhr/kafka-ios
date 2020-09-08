//
//  ViewController.swift
//  Kafka
//
//  Created by Ju on 23/07/2017.
//  Copyright © 2017 TroisYaourts. All rights reserved.
//

import UIKit
import SpriteKit

class KafkaController: UIViewController {

    @IBOutlet weak var boardView: SKView!
    @IBOutlet weak var renonceButton: UIButton?
    @IBOutlet weak var destroyButton: UIButton?
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var swipeInstruction: UIView!
    
    private var scene : BoardScene!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scene = BoardScene(size: view.bounds.size)
        self.boardView.showsFPS = false
        self.boardView.showsNodeCount = false
        self.boardView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        
        // ui
        scoreLabel.text = "0" + " pts"
        
        // swipe gesture detector
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // win event
        NotificationCenter.default.addObserver(self, selector: #selector(respondToWinEvent(notification:)), name: Notification.Name("win"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(respondToScoreChangeEvent(notification:)), name: Notification.Name("score_change"), object: nil)
        
//        // retro effect
//        let scanlinesShader = SKShader(fileNamed: "SHKScanlines.fsh")
//        
//        scanlinesShader.uniforms = [
//            SKUniform(name: "u_width", float: 4.0),
//            SKUniform(name: "u_brightness", float: 0.75)
//        ]
//        scanlinesShader.attributes = [
//            SKAttribute(name: "a_size", type: .vectorFloat2)
//        ]
//        scene.shader = scanlinesShader
        
        //GameCenter
        GameCenterHelper.helper.viewController = self
    }
    
    override func viewDidLayoutSubviews() {
        self.boardView.presentScene(scene)
    }

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            var hasMoved: Bool = false
            
            if !swipeInstruction.isHidden {
                UIView.animate(withDuration: 0.3, animations: {
                    self.swipeInstruction.alpha = 0
                }, completion:{ (_) in
                    self.swipeInstruction.isHidden = true;
                })
            }
            
            
            switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.right:
                    hasMoved = scene.movePlayer(direction: .right)
                case UISwipeGestureRecognizer.Direction.down:
                    hasMoved = scene.movePlayer(direction: .down)
                case UISwipeGestureRecognizer.Direction.left:
                    hasMoved = scene.movePlayer(direction: .left)
                case UISwipeGestureRecognizer.Direction.up:
                    hasMoved = scene.movePlayer(direction: .up)
                default:
                    break
            }
            
            if(hasMoved){
                scene.turn()
            }
        }
    }
    
    @IBAction func renonceAction(_ sender: UIButton) {
        scene.renonce()
    }

    @IBAction func destroyAction(_ sender: UIButton) {
        scene.destroy()
    }
    
    @IBAction func startOver(_ sender: UIButton) {
        performSegue(withIdentifier: "GameToHome", sender: self)
    }
    
    
    @objc func respondToWinEvent(notification: Notification){
        performSegue(withIdentifier: "WinSegue", sender: notification.object)
    }
    
    @objc func respondToScoreChangeEvent(notification: Notification){
        scoreLabel.text = String(describing: notification.object as! Int) + " pts"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WinSegue"
        {
            if let destinationVC = segue.destination as? WinController {
                destinationVC.score = (sender as! Int)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }


}

