//
//  DifficultyViewController.swift
//  Puzzle Game
//
//  Created by Simon Enström on 2018-11-20.
//  Copyright © 2018 Goobers. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var genButton: UIButton!
    @IBOutlet weak var selectDifficulty: UILabel!
    @IBOutlet weak var genLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        easyButton.layer.cornerRadius = 8
        mediumButton.layer.cornerRadius = 8
        hardButton.layer.cornerRadius = 8
        genButton.layer.cornerRadius = 8
        self.genLabel.text = ""
        UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseOut, .autoreverse, .repeat], animations: {
            self.selectDifficulty.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        Sound.instance.playAudio(name: "Regular_klick")
        //MARK: - Prepare Easy
        if segue.identifier == "EasyIdentifier" {
            let allEasylevel = Database.retrieveAllLevels(entity: "EasyLevel")
            var stages = [Stage]()
            
            for level in allEasylevel!{
                print(level.imagePath!)
                _ = level.imagePath!
                
                if let image = UIImage.init(named: level.imagePath!) {
                    stages.append(Stage(image: image, level: level))
                } else {
                    print("Image not found")
                }
            }
            
            let destination = segue.destination as! StageSelectViewController
            
            destination._displayExtendedtext = false
            destination._stages = stages
        }
        //MARK: - Prepare Medium
        if segue.identifier == "MediumIdentifier" {
            let allMediumlevel = Database.retrieveAllLevels(entity: "MediumLevel")
            var stages = [Stage]()
            
            for level in allMediumlevel!{
                print(level.imagePath!)
                _ = level.imagePath!
                
                if let image = UIImage.init(named: level.imagePath!) {
                    stages.append(Stage(image: image, level: level))
                } else {
                    print("Image not found")
                }
            }
            
            let destination = segue.destination as! StageSelectViewController
            
            destination._displayExtendedtext = false
            destination._stages = stages
        }
        //MARK: - Prepare Hard
        if segue.identifier == "HardIdentifier" {
            let allHardlevel = Database.retrieveAllLevels(entity: "HardLevel")
            var stages = [Stage]()
            
            for level in allHardlevel!{
                print(level.imagePath!)
                _ = level.imagePath!
                
                if let image = UIImage.init(named: level.imagePath!) {
                    stages.append(Stage(image: image, level: level))
                } else {
                    print("Image not found")
                }
            }
            
            let destination = segue.destination as! StageSelectViewController
            
            destination._displayExtendedtext = false
            destination._stages = stages
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier: String?, sender: Any?) -> Bool {
        //MARK: - Should perform Easy
        if withIdentifier == "EasyIdentifier" {
            let allEasyLevel = Database.retrieveAllLevels(entity: "EasyLevel")
            if (allEasyLevel?.count == 0) {
                self.onGenerateClick(genButton				)
                return false
            }
            else {
                return true
            }
        }
        //MARK: - Should perform Medium
        if withIdentifier == "MediumIdentifier" {
            let allMediumLevel = Database.retrieveAllLevels(entity: "MediumLevel")
            if (allMediumLevel?.count == 0) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.genLabel.text = "Generate Levels First !"
                    self.genLabel.alpha = 0.0
                }) { (bool) in
                    self.genLabel.alpha = 1.0
                }
                return false
            }
            else {
                return true
            }
        }
        //Mark: - Should perform Hard
        if withIdentifier == "HardIdentifier" {
            let allHardLevel = Database.retrieveAllLevels(entity: "HardLevel")
            if (allHardLevel?.count == 0) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.genLabel.text = "Generate Levels First !"
                    self.genLabel.alpha = 0.0
                }) { (bool) in
                    self.genLabel.alpha = 1.0
                }
                return false
            }
            else {
                return true
            }
        }
        return true
    }
    
    //MARK: - Generate levels and insert into database
    @IBAction func onGenerateClick(_ sender: Any) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        Sound.instance.playAudio(name: "Regular_klick")
        UIView.animate(withDuration: 0.2, animations: {
            self.genLabel.text = "Loading Levels..."
            self.genLabel.alpha = 0.0
        }) { (bool) in
            self.genLabel.alpha = 1.0
        }
        
        LevelGenerator.insertEasyLevels()
        LevelGenerator.insertMediumLevels()
        LevelGenerator.insertHardLevels()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.genLabel.text = "Done Loading Levels !"
            self.genLabel.alpha = 0.0
        }) { (bool) in
            self.genLabel.alpha = 1.0
        }
        Sound.instance.playAudio(name: "Blop sound effect")
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            Sound.instance.playAudio(name: "Regular_klick")
        }
    }
}
