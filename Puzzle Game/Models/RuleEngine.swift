//
//  RuleEngine.swift
//  Puzzle Game
//
//  Created by Oliver Karlsson on 2018-11-09.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation
import UIKit

class RuleEngine {
    
    //MARK: - Members
    
    //MARK: - Constructors
    
    func genCompleteBoard(board: Board) -> [[Int]] {
        var count: Int = 1
        var completeBoard = [[Int]]()
        for _ in 0..<board.getBoardDimensions(){
            var subStringArray = [Int]()
            for _ in 0..<board.getBoardDimensions(){
                subStringArray.append(count)
                print(String(count))
                count+=1
            }
            completeBoard.append(subStringArray)
        }
        return completeBoard
    }
    
    //MARK: - Checks if puzzle is complete
    func checkIfComplete(board: Board) -> Bool{
        var completeBoard = self.genCompleteBoard(board: board)
        var count: Int = 0
        for x in 0..<board.getBoardDimensions(){
            for y in 0..<board.getBoardDimensions(){
                if(board.getElementByXY(x: x, y: y) == completeBoard[x][y]){
                    count += 1
                }
                else{
                    count = 0
                }
            }
        }
        if count == board.getBoardDimensions() * board.getBoardDimensions(){
            return true
        }
        else {
            return false
        }
    }
    

    
    func visit(board: Board) -> [Board] {
        var children = [Board]()
        var allowedMoves = board.getAllowedMoves()
        
        for x in 0..<allowedMoves.count{
            let move = allowedMoves[x]
            
            if (move != board.getLastMove()) {
                let newInstance = board.getCopy()
                newInstance.move(piece: move)
                newInstance.pushPath(move: move)
                children.append(newInstance)
            }
        }
        return children
    }
    
    //MARK: - Returns shortest path to solve board
    func solveA(board: Board) -> [Int] {
        var states = [(Board, Int)]()
        var pathToSolve = [Int]()
        board.resetPath()
        if (self.isSolvable(board: board) == false) {
            return [-1]
        }
        states.append((board, 0))
        while (states.count > 0) {
            
            states = states.sorted(by: {$0.1 < $1.1})
            let state = states.removeFirst().0
            if (self.checkIfComplete(board: state)) {
                pathToSolve = state.getPath()
                break
            }
            else {
                var children = self.visit(board: state)
                for x in 0..<children.count{
                    let child = children[x]
                    var f = child.getPathLength() + self.manhattanDistance(board: child)
                    f += self.linearVerticalConflict(board: child)
                    f += self.linearHorizontalConflict(board: child)
                    states.append((child, f))
                }
            }
        }
        return pathToSolve
    }
    
    //MARK: - Calculates manhattan distance
    func manhattanDistance(board: Board) -> Int {
        var distance = 0
        
        for x in 0..<board.getBoardDimensions(){
            for y in 0..<board.getBoardDimensions(){
                let piece = board.getElementByXY(x: x, y: y)
                if (piece != board.getBlankSpace()) {
                    let originalLine = Int(floor(Double((piece - 1) / board.getBoardDimensions())))
                    let originalColumn = (piece - 1) % board.getBoardDimensions()
                    distance += abs(x - originalLine) + abs(y - originalColumn)
                }
            }
        }
        return distance
    }
    //MARK: - Returns number of vertical conflicts in board
    func linearVerticalConflict(board: Board) -> Int {
        let dimension = board.getBoardDimensions()
        var linearConflict = 0
        
        for row in 0..<dimension {
            var max = -1
            for column in 0..<dimension {
                let piece = board.getElementByXY(x: column, y: row)
                if (piece != board.getBlankSpace() && (piece - 1) / dimension == row) {
                    if (piece > max) {
                        max = piece
                    }
                    else {
                        linearConflict += 2
                    }
                }
            }
        }
        
        return linearConflict
    }
    
    //MARK: - Returns number of horizontal conflicts in board
    func linearHorizontalConflict(board: Board) -> Int {
        let dimension = board.getBoardDimensions()
        var linearConflict = 0
        
        for column in 0..<dimension {
            var max = -1
            for row in 0..<dimension {
                let piece = board.getElementByXY(x: column, y: row)
                if (piece != board.getBlankSpace() && piece % dimension == column + 1) {
                    if (piece > max) {
                        max = piece
                    }
                    else {
                        linearConflict += 2
                    }
                }
            }
        }
        
        return linearConflict
    }
    
    //MARK: - Gets the number of inversions in the board
    func getInvCount(board: Board) -> Int{
        var flatBoard = board.getFlattendBoard()
        var count: Int = 0
        
        for x in 0..<flatBoard.count{
            for y in x + 1..<flatBoard.count{
                if (flatBoard[x] != board.getBlankSpace() && flatBoard[y] != board.getBlankSpace()) {
                    if (flatBoard[x] > flatBoard[y]) {
                        count = count + 1
                    }
                }
            }
        }
        return count
    }
    
    //MARK: - Checks if board is solvable
    func isSolvable(board: Board) -> Bool{
        let invCount = getInvCount(board: board)
        
        if (board.getBoardDimensions() % 2 == 1) {
            return ((invCount % 2) == 0)
        }
        else {
            let blankSpace = board.getBlankSpacePos()
            if ((invCount + board.getBoardDimensions() - (blankSpace.0 - 1)) % 2 == 0) {
                if (blankSpace.0 % 2 == 0) {
                    if (invCount % 2 == 0) {
                        //print("EVEN EVEN EVEN")
                        return false
                    }
                    else {
                        //print("EVEN EVEN UNEVEN")
                        return true
                    }
                }
                else {
                    if (invCount % 2 == 0) {
                        //print("EVEN UNEVEN EVEN")
                        return true
                    }
                    else {
                        //print("EVEN UNEVEN UNEVEN")
                        return false
                    }
                }
            }
            else {
                if (blankSpace.0 % 2 == 0) {
                    if (invCount % 2 == 0) {
                        //print("UNEVEN EVEN EVEN")
                        return true
                    }
                    else {
                        //print("UNEVEN EVEN UNEVEN")
                        return false
                    }
                }
                else {
                    if (invCount % 2 == 0) {
                        //print("UNEVEN UNEVEN EVEN")
                        return false
                    }
                    else {
                        //print("UNEVEN UNEVEN UNEVEN")
                        return true
                    }
                }
            }
        }
    }
}
