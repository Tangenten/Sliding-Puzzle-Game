//
//  Sound.swift
//  Puzzle Game
//
//  Created by Simon Enström on 2018-11-09.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation
import AVFoundation

class Sound {
    
    static let instance = Sound()
    
    var audioPlayer : AVAudioPlayer?
    var musicPlayer : AVAudioPlayer?
    
    init(){
        audioPlayer = AVAudioPlayer()
        musicPlayer = AVAudioPlayer()
    }
    
    func playAudio(name: String){
        if let pathResource = Bundle.main.path(forResource: name, ofType: "mp3", inDirectory: "Sounds"){
            let finishedStepSound = NSURL(fileURLWithPath: pathResource)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: finishedStepSound as URL)
                if(audioPlayer!.prepareToPlay()){
                    print("preparation success")
                    updateAudio()
                    if(audioPlayer!.play()){
                        print("Sound play success")
                    }else{
                        print("Sound file could not be played")
                    }
                }else{
                    print("preparation failure")
                }
                
            }catch{
                print("Sound file could not be found")
            }
        }else{
            print("path not found")
        }
    }
    
    func playMusic(name: String){
        if let pathResource = Bundle.main.path(forResource: name, ofType: "mp3", inDirectory: "Sounds"){
            let finishedStepSound = NSURL(fileURLWithPath: pathResource)
            
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: finishedStepSound as URL)
                musicPlayer?.numberOfLoops = -1
                if(musicPlayer!.prepareToPlay()){
                    print("Music preparation success")
                    if(musicPlayer!.play()){
                        print("Music play success")
                    }else{
                        print("Music file could not be played")
                    }
                }else{
                    print("Music preparation failure")
                }
                
            }catch{
                print("Music file could not be found")
            }
        }else{
            print("path not found")
        }
    }
    
    func updateMusic(){
        if let x = UserDefaults.standard.object(forKey: "musicVolume") as? Float {
            musicPlayer?.volume = x
        }
    }
    
    func updateAudio(){
        if let x = UserDefaults.standard.object(forKey: "soundVolume") as? Float {
            audioPlayer?.volume = x
        }
    }

}


