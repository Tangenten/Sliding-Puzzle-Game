//
//  OptionsViewController.swift
//  Puzzle Game
//
//  Created by Simon Enström on 2018-11-05.
//  Copyright © 2018 Goobers. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    @IBOutlet weak var musicVolumeLabel: UILabel!
    @IBOutlet weak var soundVolumeLabel: UILabel!
    @IBOutlet weak var musicVolumeSlider: UISlider!
    @IBOutlet weak var soundVolumeSlider: UISlider!
    @IBOutlet weak var musicVolumeMute: UIButton!
    @IBOutlet weak var soundVolumeMute: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var saveMusicSliderValue: Float = 0.5
    var saveAudioSliderValue: Float = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Options"
        creditsButton.layer.cornerRadius = 8
        updateElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func updateElements(){
        if let x = UserDefaults.standard.object(forKey: "musicVolume") as? Float {
            musicVolumeSlider.value = x
        }
        if let x = UserDefaults.standard.object(forKey: "soundVolume") as? Float {
            soundVolumeSlider.value = x
        }
        if let x = UserDefaults.standard.object(forKey: "musicMuteState") as? Bool {
            if x == true {
                musicVolumeSlider.isEnabled = false
            }
        }
        if let x = UserDefaults.standard.object(forKey: "soundMuteState") as? Bool {
            if x == true {
                soundVolumeSlider.isEnabled = false
            }
        }
    }

    @IBAction func onMusicVolumeValueChange(_ sender: UISlider) {
        UserDefaults.standard.set(musicVolumeSlider.value, forKey: "musicVolume")
        Music.instance.updateMusic()
    }
    
    @IBAction func onSoundVolumeChange(_ sender: UISlider) {
        UserDefaults.standard.set(soundVolumeSlider.value, forKey: "soundVolume")
        Sound.instance.updateAudio()
    }
    
    @IBAction func onMusicVolumeMuteClick(_ sender: UIButton) {

        if(musicVolumeSlider.value > 0){
            saveMusicSliderValue = musicVolumeSlider.value
        }
        
        if let x = UserDefaults.standard.object(forKey: "musicMuteState") as? Bool {
            if x == true {
                UserDefaults.standard.set(false, forKey: "musicMuteState")
                musicVolumeSlider.isEnabled = true
                musicVolumeSlider.value = saveMusicSliderValue
                UserDefaults.standard.set(musicVolumeSlider.value, forKey: "musicVolume")
                Music.instance.updateMusic()
            }
            else {
                UserDefaults.standard.set(true, forKey: "musicMuteState")
                musicVolumeSlider.value = 0
                musicVolumeSlider.isEnabled = false
                UserDefaults.standard.set(musicVolumeSlider.value, forKey: "musicVolume")
                Music.instance.updateMusic()
            }
        }
        Sound.instance.playAudio(name: "Regular_klick")
    }
    
    @IBAction func onSoundVolumeMuteClick(_ sender: UIButton) {
        
        if(soundVolumeSlider.value > 0){
            saveAudioSliderValue = soundVolumeSlider.value
        }
        
        if let x = UserDefaults.standard.object(forKey: "soundMuteState") as? Bool {
            if x == true {
                UserDefaults.standard.set(false, forKey: "soundMuteState")
                soundVolumeSlider.isEnabled = true
                soundVolumeSlider.value = saveAudioSliderValue
                UserDefaults.standard.set(soundVolumeSlider.value, forKey: "soundVolume")
            }
            else {
                UserDefaults.standard.set(true, forKey: "soundMuteState")
                soundVolumeSlider.value = 0
                soundVolumeSlider.isEnabled = false
                UserDefaults.standard.set(soundVolumeSlider.value, forKey: "soundVolume")
            }
        }
        Sound.instance.playAudio(name: "Regular_klick")
    }
    @IBAction func onResetClick(_ sender: UIButton) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        Sound.instance.playAudio(name: "Regular_klick")
        soundVolumeSlider.isEnabled = true
        musicVolumeSlider.isEnabled = true
        updateElements()
        Music.instance.updateMusic()
        Sound.instance.updateAudio()
    }

    @IBAction func creditsButton(_ sender: Any) {
        Sound.instance.playAudio(name: "munljud_klick")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            Sound.instance.playAudio(name: "Regular_klick")
        }
    }
}


