//
//  HighscoreViewController.swift
//  Puzzle Game
//
//  Created by Oliver Karlsson on 2018-11-05.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation
import UIKit

struct CustomCell {
    var image: String
    var title: String
    var time: String
    var movesMade: String
}

class HighscoreTableCell : UITableViewCell{
    @IBOutlet weak var _image: UIImageView!
    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var _time: UILabel!
    @IBOutlet weak var _movesMade: UILabel!
}


class HighscoreViewController : UITableViewController {
    
    override func viewDidLoad() {
        self.title = "Highscore"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreTableCell", for: indexPath)
            as! HighscoreTableCell
        
        
       
        cell._image?.image = UIImage(named: "placeholder")
        cell._title?.text = "Title"
        cell._time?.text = "time"
        cell._movesMade?.text = "movesMade"
        
        return cell
    }
    
    
}
