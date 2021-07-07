//
//  GameViewController.swift
//  Puzzle Game
//
//  Created by Simon Enström on 2018-11-08.
//  Copyright © 2018 Goobers. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var _gameContainer: UIView!
    var _puzzle: Stage?
    private var _board = Board(boardSize: 3)
    private var _ruleEngine = RuleEngine()
    private var _imageArray = [[UIImageView]]()
    private var _widthHeight: Double = 50
    private var _movesMade: Int = 0
    private var _timer: Timer?
    private var _timeCount: Int = 0
    
    @IBOutlet weak var _timerLabel: UILabel!
    @IBOutlet weak var _movesMadeLabel: UILabel!
    
    @objc func fireTimer() {
        _timeCount += 1
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        _timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        _timer?.invalidate()
    }

    override func viewDidLoad() {
       super.viewDidLoad()
        print(_puzzle?.level.board)
        _board = Board(board: (_puzzle?.level)!)
        _board.setBlankSpace(blank: (Int(_puzzle!.level.blankSpace)))
        _ruleEngine = RuleEngine()
        let screenSize: CGRect = UIScreen.main.bounds
        _gameContainer.frame.size.width = screenSize.width - 32
        _gameContainer.frame.size.height = screenSize.width - 32
        _gameContainer.layer.borderWidth = 3.0
        _gameContainer.layer.borderColor = UIColor.black.cgColor
        
        print(screenSize.width)
        
        _widthHeight = Double(_gameContainer.frame.size.width) / Double(_board.getBoardDimensions())
        print(_widthHeight)
        printGame_board()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        upSwipe.direction = .up
        downSwipe.direction = .down
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        
    }
    
    //MARK: - Swiping
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .left) {
            switchPuzzlePieces(xPos: 1, yPos: 0)
            if(_ruleEngine.checkIfComplete(board: _board)){
                onPuzzleCompletion()
            }
        }
        
        if (sender.direction == .right) {
            switchPuzzlePieces(xPos: -1, yPos: 0)
            if(_ruleEngine.checkIfComplete(board: _board)){
                onPuzzleCompletion()
            }
        }
        
        if (sender.direction == .up) {
            switchPuzzlePieces(xPos: 0, yPos: 1)
            if(_ruleEngine.checkIfComplete(board: _board)){
                onPuzzleCompletion()
            }
        }
        
        if (sender.direction == .down) {
            switchPuzzlePieces(xPos: 0, yPos: -1)
            if(_ruleEngine.checkIfComplete(board: _board)){
                onPuzzleCompletion()
            }
        }
    }
    //MARK: - Printing puzzle on screen
    func printGame_board(){
        let _boardSize: Int  = _board.getBoardDimensions()
        var yPos: Double = 0
        //MARK: - Slice image
        var arrayPic = Image.slice(image: (_puzzle?.image)!, into: _board.getBoardDimensions())
        
        for y in 0..._boardSize-1{
            var xPos: Double = 0;
            var subImageArr = [UIImageView]()
            for x in 0..._boardSize-1{
                let image = UIImageView()
                image.frame = CGRect(x: xPos, y: yPos, width: _widthHeight, height: _widthHeight)
                image.image = nil
                if((Int(_puzzle!.level.blankSpace)) != _board.getElementByXY(x: y, y: x)){
                    image.image = arrayPic[_board.getElementByXY(x: y, y: x)-1]
                }
                subImageArr.append(image)
                xPos += _widthHeight
            }
            _imageArray.append(subImageArr)
            yPos += _widthHeight
        }
        for y in 0..<_imageArray.count{
            for x in 0..<_imageArray[y].count{
                _gameContainer.addSubview(_imageArray[y][x])
            }
        }
    }
    
    
    //MARK: - Moving Puzzle pieces
    func switchPuzzlePieces(xPos: Int, yPos: Int){
        var movemade: Int = 0
        for y in 0..<_imageArray.count{
            if(movemade==0){
                for x in 0..<_imageArray[y].count{
                    if(_imageArray[y][x].image == nil){
                        if(x+xPos < _board.getBoardDimensions() && x+xPos > -1 && y+yPos < _board.getBoardDimensions() && y+yPos > -1){
                            let tempOriginX: CGFloat = _imageArray[y+yPos][x+xPos].frame.origin.x
                            let tempOriginY: CGFloat = _imageArray[y+yPos][x+xPos].frame.origin.y
                            
                            //MARK: - Animates switch
                            UIView.animate(withDuration: 0.25) {
                                self._imageArray[y+yPos][x+xPos].frame.origin.x = self._imageArray[y][x].frame.origin.x
                                self._imageArray[y+yPos][x+xPos].frame.origin.y = self._imageArray[y][x].frame.origin.y
                            }
                            _imageArray[y][x].frame.origin.x = tempOriginX
                            _imageArray[y][x].frame.origin.y = tempOriginY
                            
                            //MARK: - Switches labels in labelArray
                            let tempLabel = _imageArray[y][x]
                            _imageArray[y][x] = _imageArray[y+yPos][x+xPos]
                            _imageArray[y+yPos][x+xPos] = tempLabel
                            
                            //MARK: - Switch elements in board
                            _board.switchBoardElements(x: y, y: x, dX: y+yPos, dY: x+xPos)
                            
                            Sound.instance.playAudio(name: "398409__caitlin-100__yank-sound-effect")
                            movemade += 1
                            self._movesMade += 1
                         //   self._movesMadeLabel.text = "Moves: " + String(_movesMade)
                            print(self._movesMade)
                            break
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: - If Puzzle is complete
    func onPuzzleCompletion(){
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        var arrayPic = Image.slice(image: (_puzzle?.image)!, into: _board.getBoardDimensions())
        
        let blankSpacePos = _board.getBlankSpacePos()
        let finalImage = arrayPic[(blankSpacePos.0 * self._board.getBoardDimensions()) + blankSpacePos.1]
        _imageArray[blankSpacePos.0][blankSpacePos.1].alpha = 0
        _imageArray[blankSpacePos.0][blankSpacePos.1].image = finalImage
        Sound.instance.playAudio(name: "winsound")
        UIView.animate(withDuration: 2, animations: {
            self._imageArray[blankSpacePos.0][blankSpacePos.1].alpha = 1
        }, completion: {
            (value: Bool) in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            self.performSegue(withIdentifier: "WinScreenIdentifier", sender: nil)
        })

        }
    
    //MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! WinScreenViewController
        destination._numberOfMovesMade = self._movesMade
        destination._timeToComplete = self._timeCount
        destination.img = (self._puzzle?.image)!
        destination._level = (self._puzzle?.level)!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            Sound.instance.playAudio(name: "Regular_klick")
        }
    }
}
