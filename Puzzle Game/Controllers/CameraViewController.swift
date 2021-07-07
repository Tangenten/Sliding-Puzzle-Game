//
//  CameraViewController.swift
//  Puzzle Game
//
//  Created by Simon Enström on 2018-11-30.
//  Copyright © 2018 Goobers. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var savePhotoButton: UIButton!
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var photoLabel: UILabel!
    
    
    @IBOutlet weak var cameraImage: UIImageView!
    
    enum ImageSource{
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoLabel.text = ""
        takePhotoButton.layer.cornerRadius = 8
        savePhotoButton.layer.cornerRadius = 8
        selectPhotoButton.layer.cornerRadius = 8
        playButton.layer.cornerRadius = 8
    }
    
    var imagePickerController : UIImagePickerController!
    //MARK: - Take image with camera
    @IBAction func onTakePhotoClick(_ sender: Any) {
        Sound.instance.playAudio(name: "Regular_klick")
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }else{
            showAlertWith(title: "Error", message: "No camera found.")
            return
        }
    }
    
    //MARK: - Save photo
    @IBAction func onSavePhotoClick(_ sender: Any) {
        Sound.instance.playAudio(name: "Regular_klick")
        guard let selectedImage = cameraImage.image else{
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer ){
        if let error = error {
            showAlertWith(title: "save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "saved!", message: "Your image has been saved to photos")
        }
    }
    
    //MARK: - Alert
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //MARK: - Select photo from phone
    @IBAction func onSelectPhotoClick(_ sender: Any) {
        Sound.instance.playAudio(name: "Regular_klick")
        selectImageFrom(.photoLibrary)
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        switch source {
            case .camera:
                imagePickerController.sourceType = .camera
            case .photoLibrary:
                imagePickerController.sourceType = .photoLibrary
        }
        present(imagePickerController, animated: true, completion: nil)
    }

    //MARK: - Prepare for/Should perform Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "PlayIdentifier" {
            
            LevelGenerator.insertCameraLevels()
            let cameraLevel = Database.retrieveAllLevels(entity: "CameraLevel")?.first
            var stages = [Stage]()
            
            let image = cameraImage.image
            let newImage = Image.removeRotationForImage(image: image!)
            
            print(newImage.debugDescription)
            stages.append(Stage(image: newImage, level: cameraLevel!))
            
            let destination = segue.destination as! GameViewController
            destination._puzzle = stages.first
        }
    }
    
    override func shouldPerformSegue(withIdentifier: String?, sender: Any?) -> Bool {
        if withIdentifier == "PlayIdentifier" {
            Sound.instance.playAudio(name: "Regular_klick")
            if (cameraImage.image == nil) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.photoLabel.text = "Pick a picture first !"
                    self.photoLabel.alpha = 0.0
                }) { (bool) in
                    self.photoLabel.alpha = 1.0
                }
                return false
            }
            else {
                return true
            }
        }
        return true
    }
    

    //MARK: - Set image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else{
            return
        }
        cameraImage.image = image
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            Sound.instance.playAudio(name: "Regular_klick")
        }
    }
}
