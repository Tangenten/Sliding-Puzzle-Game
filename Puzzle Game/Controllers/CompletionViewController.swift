//
//  CompletionViewController.swift
//  Puzzle Game
//
//  Created by Oliver Karlsson on 2018-11-21.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation
import UIKit

class CompletionViewController: UIViewController {
    @IBOutlet weak var _puzzleImage: UIImageView!
    var _timeToComplete: Int = 0
    var _numberOfMovesMade: Int = 0
    var imgPath: String = ""
    @IBOutlet weak var _timeToCompleteLabel: UILabel!
    @IBOutlet weak var _movesMadeLabel: UILabel!
    
    override func viewDidLoad() {
        self._puzzleImage.image = UIImage(named: imgPath)
        self._movesMadeLabel.text = "Number of moves made: " + String(_numberOfMovesMade)
        self._timeToCompleteLabel.text = "Time to complete: " + secondsToTime(seconds: _timeToComplete)
    }
    
    func secondsToTime(seconds: Int) -> String{
        var Hours: Int = seconds / 3600
        var Minutes: Int = seconds % 3600 / 60
        var Seconds: Int = seconds % 60
        
        var h = String(Hours)
        var m = String(Minutes)
        var s = String(Seconds)
        
        if(Hours < 10){
            h = String(0) + String(Hours)
        }
        if(Minutes < 10){
            m = String(0) + String(Minutes)
        }
        if(Seconds < 10){
            s = String(0) + String(Seconds)
        }
        
        return (h + ":" + m + ":" + s)
    }
    
}
