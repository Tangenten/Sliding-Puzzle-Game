//
//  LevelGenerator.swift
//  Puzzle Game
//
//  Created by Alfred Runn on 2018-11-20.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation
import CoreData
import Photos

class LevelGenerator {
    
    static func storeLevelFromBoard(entity: String, board: Board, count: Int) {
        
        var levelDict = Dictionary<String, Any>()
        levelDict["bestMoveCount"] = -1
        levelDict["bestTime"] = -1
        levelDict["blankSpace"] = board.getBlankSpace()
        levelDict["completed"] = false
        levelDict["completedPerfect"] = false
        
        levelDict["entityType"] = entity

        levelDict["boardSize"] = board.getBoardDimensions()
        
        let pathResource = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: "Images")
        let path = pathResource.randomElement()
        levelDict["imagePath"] = path
        
        levelDict["id"] = count
        
        let myArray = board.getFlattendBoard()
        var myString = ""
        _ = myArray.map{ myString = myString + "\($0) " }
        levelDict["board"] = myString
        
        let ruleEngine = RuleEngine()
        levelDict["minMovesComplete"] = ruleEngine.solveA(board: board).count
        
        Database.createFromDict(entity: entity, dict: levelDict)
    }
    
    static func storeLevelFromBoardImageNr(entity: String, board: Board, count: Int, imageNr: Int) {
        
        var levelDict = Dictionary<String, Any>()
        levelDict["bestMoveCount"] = -1
        levelDict["bestTime"] = -1
        levelDict["blankSpace"] = board.getBlankSpace()
        levelDict["completed"] = false
        levelDict["completedPerfect"] = false
        
        levelDict["entityType"] = entity

        levelDict["boardSize"] = board.getBoardDimensions()
        
        let pathResource = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: "Images")
        let path = pathResource[imageNr]
        levelDict["imagePath"] = path
        
        levelDict["id"] = count
        
        let myArray = board.getFlattendBoard()
        var myString = ""
        _ = myArray.map{ myString = myString + "\($0) " }
        levelDict["board"] = myString
        
        let ruleEngine = RuleEngine()
        levelDict["minMovesComplete"] = ruleEngine.solveA(board: board).count
        
        Database.createFromDict(entity: entity, dict: levelDict)
    }
    
    static func storeLevelFromBoardImageString(entity: String, board: Board, imageString: URL, count: Int){
        var levelDict = Dictionary<String, Any>()
        levelDict["bestMoveCount"] = -1
        levelDict["bestTime"] = -1
        levelDict["blankSpace"] = board.getBlankSpace()
        levelDict["completed"] = false
        levelDict["completedPerfect"] = false
        
        levelDict["entityType"] = entity
        
        levelDict["boardSize"] = board.getBoardDimensions()
        
        levelDict["imagePath"] = imageString.absoluteString
        
        levelDict["id"] = count
        
        let myArray = board.getFlattendBoard()
        var myString = ""
        _ = myArray.map{ myString = myString + "\($0) " }
        levelDict["board"] = myString
        
        let ruleEngine = RuleEngine()
        levelDict["minMovesComplete"] = ruleEngine.solveA(board: board).count
        
        Database.createFromDict(entity: entity, dict: levelDict)
        
    }
    
    static func storeLevelFromDbClass(entity: String, board: Level, count: Int) {
        
        var levelDict = Dictionary<String, Any>()
        levelDict["bestMoveCount"] = Int(board.bestMoveCount)
        levelDict["bestTime"] = board.bestTime
        levelDict["blankSpace"] = Int(board.blankSpace)
        levelDict["completed"] = board.completed
        levelDict["completedPerfect"] = board.completedPerfect
        
        levelDict["entityType"] = board.entityType
        
        levelDict["boardSize"] = Int(board.boardSize)
        
        levelDict["imagePath"] = board.imagePath
        
        levelDict["id"] = count
        
        levelDict["board"] = board.board
        
        levelDict["minMovesComplete"] = Int(board.minMovesComplete)
        
        Database.createFromDict(entity: entity, dict: levelDict)
    }
    
    static func genAllLevels() {
        let boardSizeLimit = 4
        
        var lastF = 0
        var states = [(Board, Int)]()
        var insertionCount = 0
        
        Database.deleteAllRows(entity: "AllLevel")
        
        for x in 1..<boardSizeLimit{
            let myBoard = Board(boardSize: x+1)
            let myRuleEngine = RuleEngine()
            let boardSize = myBoard.getBoardDimensions() * myBoard.getBoardDimensions()
            
            for _ in 0..<boardSize {
                
                states.removeAll()
                states.append((myBoard, 0))
                
                while (states.count > 0) {
                    states = states.sorted(by: {$0.1 < $1.1})
                    let state = states.removeFirst().0
                    
                    var children = myRuleEngine.visit(board: state)
                    for x in 0..<children.count{
                        let child = children[x]
                        let f = 0 + myRuleEngine.manhattanDistance(board: child)
                        if (f >= lastF){
                            states.append((child, f))
                            lastF = f
                            self.storeLevelFromBoard(entity: "AllLevel", board: state, count: insertionCount)
                            insertionCount += 1
                        }
                    }
                }
                
                lastF = 0
                myBoard.shiftBlankSpaceBackwards()
            }
        }
        print("Done Generating Levels")
    }
    
    //MARK: - Generate levels
    static func genLevels(boardSize: Int, moveCount: Int, blankSpace: Int) -> [Board] {
        var lastF = 0
        var states = [(Board, Int)]()
        var boards = [Board]()
        
        let myBoard = Board(boardSize: boardSize)
        myBoard.setBlankSpace(blank: blankSpace)
        let myRuleEngine = RuleEngine()
        
        states.removeAll()
        states.append((myBoard, 0))
        
        while (states.count > 0) {
            states = states.sorted(by: {$0.1 < $1.1})
            let state = states.removeFirst().0
            
            if (state.getPathLength() == moveCount){
                boards.append(state)
            }
            else {
                var children = myRuleEngine.visit(board: state)
                for x in 0..<children.count{
                    let child = children[x]
                    let f = 0 + myRuleEngine.manhattanDistance(board: child)
                    if (f >= lastF && child.getPathLength() <= moveCount){
                        states.append((child, f))
                        lastF = f
                    }
                }
            }
        }
        
        print("Done Generating Levels")
        return boards
    }
    
    //MARK: - Returns randomized board
    static func getRandBoard(minBoardSize: Int, maxBoardSize: Int, maxMoveCount: Int) -> Board {
        
        let randBoardSize = Int.random(in: minBoardSize ..< maxBoardSize+1)
        let randBoard = Board(boardSize: randBoardSize)
        let randBlankSpace = Int.random(in: 1 ..< (randBoardSize * randBoardSize))
        let randMoveCount = Int.random(in: 1 ..< maxMoveCount)
        randBoard.setBlankSpace(blank: randBlankSpace)
        randBoard.shuffleUsingRandomMoves(moves: randMoveCount)
        return randBoard
        
        return Board(boardSize: 3)
    }
    //MARK: - Insert levels into database
    static func insertEasyLevels(){
        Database.deleteAllRows(entity: "EasyLevel")
        
        for x in 0..<5{
            let randBoard = self.getRandBoard(minBoardSize: 2, maxBoardSize: 3, maxMoveCount: 6)
            self.storeLevelFromBoard(entity: "EasyLevel", board: randBoard, count: x)
        }
    }
    
    static func insertMediumLevels(){
        Database.deleteAllRows(entity: "MediumLevel")
        
        for x in 0..<5{
            let randBoard = self.getRandBoard(minBoardSize: 3, maxBoardSize: 3, maxMoveCount: 10)
            self.storeLevelFromBoard(entity: "MediumLevel", board: randBoard, count: x)
        }
    }
    
    static func insertHardLevels(){
        Database.deleteAllRows(entity: "HardLevel")
        
        for x in 0..<5{
            let randBoard = self.getRandBoard(minBoardSize: 3, maxBoardSize: 4, maxMoveCount: 15)
            self.storeLevelFromBoard(entity: "HardLevel", board: randBoard, count: x)
        }
    }
    
    static func insertCameraLevels() {
        Database.deleteAllRows(entity: "CameraLevel")
        let board = self.getRandBoard(minBoardSize: 2, maxBoardSize: 4, maxMoveCount: 16)
        self.storeLevelFromBoard(entity: "CameraLevel", board: board, count: 0)
    }
    
}
