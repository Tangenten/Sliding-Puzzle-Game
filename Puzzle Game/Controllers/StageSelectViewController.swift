//
//  StageSelectViewController.swift
//  Puzzle Game
//
//  Created by Simon Enström on 2018-11-08.
//  Copyright © 2018 Goobers. All rights reserved.
//
import UIKit


struct Stage {
    var image: UIImage
    var level: Level
}

class StageSelectViewCell: UITableViewCell {
    @IBOutlet weak var _image: UIImageView!
    @IBOutlet weak var _stageLabel: UILabel!
    @IBOutlet weak var _checkmarkImage: UIImageView!
    
}
class StageSelectViewController: UITableViewController {
    var _displayExtendedtext: Bool = true
    var _stages = [Stage]()

    //MARK: - Get number of cells to print
    override func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _stages.count    }
    
    //MARK: - Set tableCell values
    override func tableView(_ tableview: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! StageSelectViewCell
        
        let stage = _stages[indexPath.row]
        cell._image?.image = stage.image
        let dbLevel = Database.retrieveLevels(entity: stage.level.entityType!, key: "id", value: String(stage.level.id))?.first
        cell._checkmarkImage.image = nil
        if (dbLevel?.completed == true) {
            cell._checkmarkImage.image = UIImage(named: "greenChecky")
        }
        if (dbLevel?.completedPerfect == true) {
            cell._checkmarkImage.image = UIImage(named: "blueChecky")
        }
        
        let textString = "Boardsize: " + String(stage.level.boardSize) + "/" + String(stage.level.boardSize)
        cell._stageLabel?.text = textString

        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Stage"
        self.tableView.reloadData()
    }
    
    //MARK: - Send puzzle to GameViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Sound.instance.playAudio(name: "Regular_klick")
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            let destination = segue.destination as! GameViewController
            let stage = _stages[indexPath.row]
            destination._puzzle = stage
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            Sound.instance.playAudio(name: "Regular_klick")
        }
    }
}
