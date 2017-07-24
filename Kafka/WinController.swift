//
//  ViewController.swift
//  Kafka
//
//  Created by Ju on 23/07/2017.
//  Copyright © 2017 TroisYaourts. All rights reserved.
//

import UIKit

class WinController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    public var score: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scoreLabel.text = String(score) + " pts"
    }

    @IBAction func startOver(_ sender: UIButton) {
        performSegue(withIdentifier: "WinToHome", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

