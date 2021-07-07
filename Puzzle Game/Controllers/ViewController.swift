//
//  ViewController.swift
//  Puzzle Game
//
//  Created by Alfred Runn on 2018-11-02.
//  Copyright © 2018 Goobers. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var header: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        playButton.layer.cornerRadius = 8
        optionsButton.layer.cornerRadius = 8
    }
    
    //MARK: - Buttons
    @IBAction func playButton(_ sender: Any) {
        Sound.instance.playAudio(name: "Regular_klick")
    }
    
    @IBAction func optionsButton(_ sender: Any) {
        Sound.instance.playAudio(name: "Regular_klick")
    }
    
}

