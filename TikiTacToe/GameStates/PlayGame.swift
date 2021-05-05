//
//  PlayGame.swift
//  TikiTacToe
//
//  Created by Pro on 27.01.2021.
//

import GameplayKit
import SpriteKit

class GamePlaying: GKState {
    
    var scene: GameScene?
    var isWaiting: Bool
    
    var winsArray = [Int]()
    
    init(scene: GameScene) {
        self.scene = scene
        isWaiting = false
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool { return stateClass == GameEnding.self }
    override func didEnter(from previousState: GKState?) { isWaiting = false }
    
    override func update(deltaTime seconds: TimeInterval) {
        if !isWaiting {
            isWaiting = true
            updateGameState()
        }
    }
    
    func markLevelAsDone(gameResult: Int) {
    
        // to fill array with previous values
        winsArray = UserDefaults.standard.array(forKey: "winsArr") as? [Int] ?? []
        
        let completed = UserDefaults.standard.integer(forKey: "completedLevel") + 1
        print("completed \(completed)")
        
        UserDefaults.standard.setValue(completed, forKey: "completedLevel")
        
        // 0 - lose, 1 - win, 2 - draw
        if gameResult == 0 {
            winsArray.append(0)
        } else if gameResult == 1 {
            winsArray.append(1)
        } else {
            winsArray.append(2)
        }
        
        print(winsArray)
        
        // if level is restarted - delete last chest image from winsArray
        if UserDefaults.standard.integer(forKey: "restarted") == 1 {
            winsArray.removeLast()
            print("winsArr is \(winsArray)")
            UserDefaults.standard.setValue(0, forKey: "restarted")
        }
        
        UserDefaults.standard.setValue(winsArray, forKey: "winsArr")
    }
    
    func updateGameState() {
        let (state, winner) = self.scene!.gameBoard!.checkForWinner()
        
        if state == .winner {
            let winLabel = self.scene?.childNode(withName: "winLabel")
            winLabel?.isHidden = true
            let winPlayer = self.scene!.gameBoard!.isPlayer1(winner!) ? "1" : "2"
            
            if let winLabel = winLabel as? SKSpriteNode,
               let player1Score = self.scene?.childNode(withName: "//player1Score") as? SKLabelNode,
               let player2Score = self.scene?.childNode(withName: "//player2Score") as? SKLabelNode {
                
                if winPlayer == "1" {
                    winLabel.texture = SKTexture(imageNamed: "winLabel")
                    markLevelAsDone(gameResult: 1)
                    
                } else if winPlayer == "2" {
                    winLabel.texture = SKTexture(imageNamed: "loseLabel")
                    markLevelAsDone(gameResult: 0)
                }
                
                winLabel.isHidden = false
                
                if winPlayer == "1" { player1Score.text = "\(Int(player1Score.text!)! + 1)" }
                else { player2Score.text = "\(Int(player2Score.text!)! + 1)" }
                
                // set scores
                if (Int(player1Score.text!))! > UserDefaults.standard.integer(forKey: "playerBestScore") {
                    UserDefaults.standard.setValue(Int(player1Score.text!), forKey: "playerBestScore")
                }
                
                if (Int(player2Score.text!))! > UserDefaults.standard.integer(forKey: "machineBestScore")  {
                    UserDefaults.standard.setValue(Int(player2Score.text!), forKey: "machineBestScore")
                }
                
                self.stateMachine?.enter(GameEnding.self)
                isWaiting = false
            }
        } else if state == .draw {
            let winLabel = self.scene?.childNode(withName: "winLabel")
            winLabel?.isHidden = true
            
            if let winLabel = winLabel as? SKSpriteNode {
                winLabel.texture = SKTexture(imageNamed: "drawLabel")
                winLabel.isHidden = false
            }
            
            markLevelAsDone(gameResult: 2)
            
            self.stateMachine?.enter(GameEnding.self)
            isWaiting = false
            
        } else if self.scene!.gameBoard!.isPlayer2Turn() {
            
            let completion = colorActivePlayer(.ai, with: .yellow)
            
            self.scene?.isUserInteractionEnabled = false
            
            DispatchQueue.global(qos: .default).async {
                
                self.scene!.AI.gameModel = self.scene!.gameBoard!
                let turn = self.scene!.AI.bestMoveForActivePlayer() as? Step
                
                let aiTime = CFAbsoluteTimeGetCurrent()
                let delta = CFAbsoluteTimeGetCurrent() - aiTime
                let aiTimeMax: TimeInterval = 1.0
                
                let delay = min(aiTimeMax - delta, aiTimeMax)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
                    
                    guard let cellNode: SKSpriteNode = self.scene?.childNode(withName: self.scene!.gameBoard!.getElemAtBoardLocation(turn!.cell).node) as? SKSpriteNode
                    else { return }
                    
                    let imgSize = CGSize(width: Consts.cellSize + 40, height: Consts.cellSize + 40)
                    
                    let oo = SKSpriteNode(imageNamed: Consts.oCell)
                    oo.size = imgSize
                    cellNode.alpha = 0.0
                    cellNode.addChild(oo)
                    
                    let show = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
                    cellNode.run(show)
                    
                    self.scene!.gameBoard!.addPlayerValueAtBoardLocation(turn!.cell, value: .o)
                    self.scene!.gameBoard!.togglePlayer()
                    self.isWaiting = false
                    self.scene?.isUserInteractionEnabled = true
                    
                    completion()
                }
            }
        } else {
            self.isWaiting = false
            self.scene?.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func colorActivePlayer(_ player: CurrentPlayer, with color: UIColor) -> () -> ()? {
        
        let labelNodeName = player == .human ? "player1Label" : "player2Label"
        
        var font: UIColor?
        var label: SKLabelNode?
        
        if let playerNode = self.scene?.childNode(withName: labelNodeName) as? SKLabelNode {
            label = playerNode
            font = playerNode.fontColor
            playerNode.fontColor = color
        }
        
        let completion = { label?.fontColor = font }
        
        return completion
    }
}
