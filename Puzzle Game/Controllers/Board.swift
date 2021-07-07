//
//  Board.swift
//  Puzzle Game
//
//  Created by Oliver Karlsson on 2018-11-08.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation

class Board {
    private var _puzzleBoard: [[Int]] = []
    private var _boardDimension: Int
    
    init(){
        self._boardDimension = 3
        var count = 1
        for y in 0..._boardDimension{
            for x in 0..._boardDimension{
                self._puzzleBoard[x][y] = count
                count += 1
            }
        }
        
        
    }

    func getElementByXY(x: Int, y: Int) -> Int {
        return self._puzzleBoard[x][y]
    }
    
    func getBoardDimensions() -> Int {
        return self._boardDimension
    }
    
}
