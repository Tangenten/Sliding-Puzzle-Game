//
//  WinScreenViewController.swift
//  Puzzle Game
//
//  Created by Alfred Runn on 2018-11-29.
//  Copyright © 2018 Goobers. All rights reserved.
//

import UIKit

class WinScreenViewController: UIViewController {
    @IBOutlet weak var newMapButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var BestTime: UILabel!
    @IBOutlet weak var MinimumMoves: UILabel!
    @IBOutlet weak var BestMoves: UILabel!
    @IBOutlet weak var WinnerDinner: UILabel!
    var _timeToComplete: Int = 0
    var _numberOfMovesMade: Int = 0
    var _level = Level()
    var img = UIImage()
    
    @IBAction func onNewMapClick(_ sender: Any) {
        Sound.instance.playAudio(name: "Regular_klick")
    }
    override func viewDidLoad() {
        newMapButton.layer.cornerRadius = 8
        
        var dbLevel = Database.retrieveLevels(entity: self._level.entityType!, key: "id", value: String(self._level.id))?.first
        var updateDict = Dictionary<String, Any>()
        
        if (_numberOfMovesMade < Int(dbLevel!.bestMoveCount) || Int(dbLevel!.bestMoveCount) == -1) {
            updateDict["bestMoveCount"] = _numberOfMovesMade
        }
        if (_timeToComplete <= Int(dbLevel!.bestTime) || Int(dbLevel!.bestTime) == -1) {
            updateDict["bestTime"] = _timeToComplete
        }
        
        updateDict["completed"] = true
        if (_numberOfMovesMade <= dbLevel!.minMovesComplete) {
            updateDict["completedPerfect"] = true
        }
        var integ = "\(dbLevel?.id ?? -1)"
        var idString = String(integ)
        Database.updateFromDict(entity: self._level.entityType!, key: "id", value: idString, dict: updateDict)
        
        dbLevel = Database.retrieveLevels(entity: self._level.entityType!, key: "id", value: String(self._level.id))?.first
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.image.image = img
        self.movesLabel.text = "Number of moves made: " + String(_numberOfMovesMade)
        self.timeLabel.text = "Time to complete: " + secondsToTime(seconds: _timeToComplete)
        self.BestTime.text = "Your Best Time: " + String(secondsToTime(seconds: Int(dbLevel!.bestTime)))
        self.BestMoves.text = "Your Best Moves Made: " + String(dbLevel!.bestMoveCount)
        self.MinimumMoves.text = "Minimum Possible Moves: " + String(dbLevel!.minMovesComplete)
        UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseOut, .autoreverse, .repeat], animations: {
            self.WinnerDinner.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })
    }
    
}
