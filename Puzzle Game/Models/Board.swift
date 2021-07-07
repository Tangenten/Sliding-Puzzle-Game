//
//  Board.swift
//  Puzzle Game
//
//  Created by Oliver Karlsson on 2018-11-08.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation

class Board {
    
    //MARK: - Members
    private var _puzzleBoard = [[Int]]()
    private var _blankSpace: Int
    private var _boardDimension: Int
    private var _path: [Int]
    private var _lastMove: Int?
    
    //MARK: - Constructors
    init(boardSize: Int){
        self._boardDimension = boardSize
        self._path = []
        self._lastMove = nil
        self._blankSpace = boardSize * boardSize
        
        self.resetBoard()
    }
    
    init(board: Level){
        self._boardDimension = Int(board.boardSize)
        self._path = []
        self._lastMove = nil
        self._blankSpace = Int(board.blankSpace)
        
        self.flatTo2d(flat: board.board!)
        
    }
    
    //MARK: - Getters
    func getElementByXY(x: Int, y: Int) -> Int {return self._puzzleBoard[x][y]}
    
    func getBoard() -> [[Int]] {return self._puzzleBoard}
    
    func getLastMove() -> Int? {return self._lastMove}
    
    func getBoardDimensions() -> Int {return self._boardDimension}
    
    func getPath() -> [Int] {return self._path}
    
    func getPathLength() -> Int {return self._path.count}
    
    func getBlankSpace() -> Int {return self._blankSpace}
    
    func getFlattendBoard() -> [Int] {return Array(_puzzleBoard.joined())}
    
    func getMove(piece: Int) -> String {
        let blankSpacePosition = self.getBlankSpacePos()
        let line = blankSpacePosition.0
        let column = blankSpacePosition.1
        
        if (line > 0 && piece == self._puzzleBoard[line-1][column]){
            return "Down"
        } else if (line < self._boardDimension - 1 && piece == self._puzzleBoard[line+1][column]) {
            return "Up"
        } else if (column > 0 && piece == self._puzzleBoard[line][column-1]) {
            return "Right"
        } else if (column < self._boardDimension - 1 && piece == self._puzzleBoard[line][column+1]) {
            return "Left"
        }
        return "None"
    }
    
    //MARK: - Finds position of blank space in board
    func getBlankSpacePos() -> (Int, Int) {
        var blankPos = (0, 0)
        for x in 0..<_boardDimension{
            for y in 0..<_boardDimension{
                if (_puzzleBoard[x][y] == _blankSpace){
                    blankPos = (x, y)
                    break
                }
            }
        }
        return blankPos
    }
    
    //MARK: - Return copy of board
    func getCopy() -> Board {
        let newBoard = Board(boardSize: _boardDimension)
        
        for x in 0..<self.getBoardDimensions(){
            for y in 0..<self.getBoardDimensions(){
                newBoard._puzzleBoard[x][y] = self._puzzleBoard[x][y]
            }
        }
        for x in 0..<self._path.count{
            newBoard._path.append(self._path[x])
        }
        newBoard._blankSpace = self._blankSpace
        return newBoard
    }
    
    //MARK: -
    func getAllowedMoves() -> [Int] {
        var allowedMoves = [Int]()
        
        for x in 0..<self.getBoardDimensions(){
            for y in 0..<self.getBoardDimensions(){
                let piece = self.getElementByXY(x: x, y: y)
                if (self.getMove(piece: piece) != "None") {
                    allowedMoves.append(piece)
                }
            }
        }
        return allowedMoves
    }
    

    //MARK: - Setters
    func setBlankSpace(blank: Int) {
        self._blankSpace = blank
    }
    
    //MARK: - Increments/Push
    func pushPath(move: Int) {
        self._path.append(move)
    }
    
    //MARK: - Resets
    func resetBoard() {
        self._path = []
        self._lastMove = nil
        var count = 1
        self._puzzleBoard.removeAll()
        
        for _ in 0..._boardDimension-1{
            var subArray = [Int]()
            for _ in 0..._boardDimension-1{
                subArray.append(count)
                count += 1
            }
            self._puzzleBoard.append(subArray)
        }
    }
    
    func resetPath() {
        self._path = []
    }
    
    //MARK: - Convert 2d array to flat
    func flatTo2d(flat: String) {
        var stringArray = flat.components(separatedBy: " ")
        stringArray.removeLast()
        let intArray = stringArray.map { Int($0)!}
        var count = 0
        
        self._puzzleBoard.removeAll()
        
        for _ in 0..<_boardDimension{
            var subArray = [Int]()
            for _ in 0..<_boardDimension{
                subArray.append(intArray[count])
                count += 1
            }
            self._puzzleBoard.append(subArray)
        }
    }
    
    func move(piece: Int) -> String {
        let move = self.getMove(piece: piece)
        
        if (move != "None") {
            let blankSpacePosition = self.getBlankSpacePos()
            let line = blankSpacePosition.0
            let column = blankSpacePosition.1
            
            switch (move) {
            case "Left":
                self.switchBoardElements(x: line, y: column, dX: line, dY: column+1)
                break
            case "Right":
                self.switchBoardElements(x: line, y: column, dX: line, dY: column-1)
                break
            case "Up":
                self.switchBoardElements(x: line, y: column, dX: line+1, dY: column)
                break
            case "Down":
                self.switchBoardElements(x: line, y: column, dX: line-1, dY: column)
                break
            default:
                break
            }
            if (move != "None") {
                self._lastMove = piece
            }
            return move
        }
        return "None"
    }
    
    //MARK: - Switches two elements in the puzzleboard
    func switchBoardElements(x: Int, y: Int, dX: Int, dY: Int){
        let temp = _puzzleBoard[x][y]
        self._puzzleBoard[x][y] = self._puzzleBoard[dX][dY]
        self._puzzleBoard[dX][dY] = temp
    }
    
    func shiftBlankSpaceBackwards() {
        self._blankSpace = self._blankSpace - 1
        self._blankSpace = self._blankSpace >= 1 ? self._blankSpace : self._boardDimension * self._boardDimension
    }
    
    //MARK: - Shuffle
    func shufflePureRandom() {
        self._puzzleBoard = self._puzzleBoard.shuffled()
    }
    
    func shuffleUsingRandomMoves(moves: Int) {
        for _ in 0..<moves{
            let allowedMoves = self.getAllowedMoves()
            let move = allowedMoves.randomElement()!
            if (move != self._lastMove) {
                self.move(piece: move)
            }
        }
        self._path = []
        self._lastMove = nil
    }
}
