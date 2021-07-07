//
//  CreditsViewController.swift
//  Puzzle Game
//
//  Created by Simon Enström on 2018-11-05.
//  Copyright © 2018 Goobers. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {
    

    @IBOutlet weak var Creators: UILabel!
    @IBOutlet weak var Credits: UILabel!
    @IBOutlet weak var Oliver: UILabel!
    @IBOutlet weak var Simon: UILabel!
    @IBOutlet weak var Joacim: UILabel!
    @IBOutlet weak var Alfred: UILabel!
    @IBOutlet weak var Karlsson: UILabel!
    @IBOutlet weak var Enström: UILabel!
    @IBOutlet weak var Lilja: UILabel!
    @IBOutlet weak var Runn: UILabel!
    @IBOutlet weak var Content_Text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Credits"
        
        UIView.animate(withDuration: 1/4, delay: 0, options: [.curveEaseOut, .autoreverse, .repeat], animations: {
            self.Creators.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.Oliver.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.Simon.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.Joacim.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.Alfred.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.Karlsson.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.Enström.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.Lilja.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.Runn.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.Content_Text.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)})
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            Sound.instance.playAudio(name: "Regular_klick")
        }
    }
}

