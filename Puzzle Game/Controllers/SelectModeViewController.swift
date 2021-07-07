//
//  SelectModeViewController.swift
//  Puzzle Game
//
//  Created by Simon Enström on 2018-11-29.
//  Copyright © 2018 Goobers. All rights reserved.
//

import UIKit

class SelectModeViewController: UIViewController {
    
    @IBOutlet weak var APIButton: UIButton!
    @IBOutlet weak var StorageButton: UIButton!
    @IBOutlet weak var CameraButton: UIButton!
    @IBOutlet weak var GenAPIButton: UIButton!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var selectMode: UILabel!
    @IBOutlet weak var mainMenuButton: UIButton!
    
    var _stages = [Stage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.loadingLabel.text = "Loading Levels, Please Wait !"
        self.loadingLabel.alpha = 0.0
        APIButton.layer.cornerRadius = 8
        StorageButton.layer.cornerRadius = 8
        CameraButton.layer.cornerRadius = 8
        GenAPIButton.layer.cornerRadius = 8
        mainMenuButton.layer.cornerRadius = 8
        
        UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseOut, .autoreverse, .repeat], animations: {
            self.selectMode.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })
    }
    
    //MARK: - Prepare for API Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        Sound.instance.playAudio(name: "Regular_klick")
        if segue.identifier == "APIIdentifier" {
            let allAPILevel = Database.retrieveAllLevels(entity: "APILevel")
            var stages = [Stage]()
        
            for level in allAPILevel!{
                print(String((level.imagePath?.dropFirst(7))!))
                if let image = UIImage.init(contentsOfFile: String((level.imagePath?.dropFirst(7))!)) {
                    stages.append(Stage(image: image, level: level))
                } else {
                    print("Image not found")
                }
            }
        
            let destination = segue.destination as! StageSelectViewController
            destination._stages = stages
            destination.tableView.reloadData()
            }
        }
    
    //MARK: - Should Perform API Segue
    override func shouldPerformSegue(withIdentifier: String?, sender: Any?) -> Bool {
        if withIdentifier == "APIIdentifier" {
            let allAPILevel = Database.retrieveAllLevels(entity: "APILevel")
            let allAPIImages = Image.getImageURLsFromAPIImageDirectory()
            if (allAPILevel?.count == 0 || allAPIImages?.count == 0) {
                self.generateAPILibrary(self.GenAPIButton)
                return false
            }
            else {
                    return true
            }
        }
        return true
    }

    //MARK: - 
    func showError () {
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingLabel.text = "Failed Loading Levels"
            self.loadingLabel.alpha = 0.0
        }) { (bool) in
            self.loadingLabel.alpha = 1.0
        }
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    //MARK: - Generate API Levels if connected to internet
    @IBAction func generateAPILibrary(_ sender: UIButton) {
        if(InternetConnection.isConnectedToNetwork()){
            UIApplication.shared.beginIgnoringInteractionEvents()
            Sound.instance.playAudio(name: "Regular_klick")
            UIView.animate(withDuration: 0.2, animations: {
                self.loadingLabel.text = "Loading Levels..."
                self.loadingLabel.alpha = 0.0
            }) { (bool) in
                self.loadingLabel.alpha = 1.0
            }
            
            
            Image.createAPIImageDirectory()
            Image.clearAPIImageDirectory()
            Database.deleteAllRows(entity: "APILevel")
            
            
            var images: [ImagesAPI] = []
            //MARK: - Get images through API
            var error = false
            
            RestHandler.getImages { (success) in
                images = DataHandler.instance._images
                if (images.count != 0) {
                    let rand: Int = Int.random(in: 0...900)
                    for i in rand...rand+5 {
                        let url = URL(string: "https://picsum.photos/400/400?image=" + String(images[i].id))
                        if let imageData = try? Data(contentsOf: url!){
                            let image = UIImage(data: imageData)
                            Image.saveImageToAPIImageDirectory(image: image!, name: String(i))
                        }
                        else {
                            error = true
                        }
                    }
                }
                else {
                    error = true
                }


                DispatchQueue.main.async {
                    let apiImageStrings = Image.getImageURLsFromAPIImageDirectory()
                    
                    var count = 0
                    for image in apiImageStrings! {
                        let randBoard = LevelGenerator.getRandBoard(minBoardSize: 2, maxBoardSize: 4, maxMoveCount: 20)
                        LevelGenerator.storeLevelFromBoardImageString(entity: "APILevel", board: randBoard, imageString: image, count: count)
                        count += 1
                    }
                    if (error == true) {
                        self.loadingLabel.text = "Failed Loading Levels"
                    }
                    else {
                        self.loadingLabel.text = "Done Loading Levels !"
                    }
                    Sound.instance.playAudio(name: "Blop sound effect")
                    UIApplication.shared.endIgnoringInteractionEvents()

                }
            }
        }
        else{
            let ac = UIAlertController(title: "No internet connection", message: "Can't download new images", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

}
