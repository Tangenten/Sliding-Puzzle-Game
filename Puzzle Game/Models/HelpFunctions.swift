//
//  HelpFunctions.swift
//  Puzzle Game
//
//  Created by Oliver Karlsson on 2018-12-05.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation

//MARK: - Convert seconds into a HH:MM:SS String
func secondsToTime(seconds: Int) -> String{
    let Hours: Int = seconds / 3600
    let Minutes: Int = seconds % 3600 / 60
    let Seconds: Int = seconds % 60
    
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


