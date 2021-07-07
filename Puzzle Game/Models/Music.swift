//
//  Music.swift
//  Puzzle Game
//
//  Created by Alfred Runn on 2018-12-05.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation
import AVFoundation

class Music: NSObject, AVAudioPlayerDelegate {
    
    static let instance = Music()
    
    var musicPlayer : AVAudioPlayer?
    
    override init(){
        musicPlayer = AVAudioPlayer()
    }
    
    //MARK: - Plays Music.
    func playMusic(name: String){
        if let pathResource = Bundle.main.path(forResource: name, ofType: "mp3", inDirectory: "Music"){
            let finishedStepSound = NSURL(fileURLWithPath: pathResource)
            
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: finishedStepSound as URL)
                musicPlayer?.numberOfLoops = 0
                musicPlayer?.delegate = self
                Music.instance.updateMusic()
                //musicPlayer?.numberOfLoops = -1
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
    
    //MARK: - Plays random music file when last music is finished. (Is called automaticly)
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        let pathResource = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "Music")
        let path = pathResource.randomElement()
        let theFileName = ((path as! NSString).lastPathComponent)
        
        self.playMusic(name: String(theFileName.dropLast(4)))
    }
    
    //MARK: - Update Music Volume.
    func updateMusic(){
        if let x = UserDefaults.standard.object(forKey: "musicVolume") as? Float {
            musicPlayer?.volume = x
        }
    }
    
}

