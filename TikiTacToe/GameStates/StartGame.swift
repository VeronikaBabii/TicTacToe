//
//  StartGame.swift
//  TikiTacToe
//
//  Created by Pro on 27.01.2021.
//

import GameplayKit
import SpriteKit

class GameStarting: GKState {
    
    var scene: GameScene?
    var winLabel: SKNode!
    var restartNode: SKNode!
    var board: SKNode!
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == GamePlaying.self
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        restartGame()
        scene?.turnsAIthinkOf(lvl: scene?.level ?? 1)
        self.stateMachine?.enter(GamePlaying.self)
    }
    
    func restartGame() {
        let topLeft: BoardCell  = BoardCell(value: .none, node: "//*top_left")
        let middleLeft: BoardCell = BoardCell(value: .none, node: "//*middle_left")
        let bottomLeft: BoardCell = BoardCell(value: .none, node: "//*bottom_left")
        
        let topMiddle: BoardCell = BoardCell(value: .none, node: "//*top_middle")
        let center: BoardCell = BoardCell(value: .none, node: "//*center")
        let bottomMiddle: BoardCell = BoardCell(value: .none, node: "//*bottom_middle")
        
        let topRight: BoardCell = BoardCell(value: .none, node: "//*top_right")
        let middleRight: BoardCell = BoardCell(value: .none, node: "//*middle_right")
        let bottomRight: BoardCell = BoardCell(value: .none, node: "//*bottom_right")
        
        board = self.scene?.childNode(withName: "//Grid") as? SKSpriteNode
        
        winLabel = self.scene?.childNode(withName: "winLabel")
        winLabel.isHidden = true
        
        restartNode = self.scene?.childNode(withName: Consts.restart)
        restartNode.isHidden = true
        restartNode.alpha = 0.0
        
        let board = [topLeft, topMiddle, topRight, middleLeft, center, middleRight, bottomLeft, bottomMiddle, bottomRight]
        
        let currentPlayer = scene?.humanOrAI() ?? .human
        self.scene?.gameBoard = Grid(gameboard: board, currentPlayer: currentPlayer)
        
        self.scene?.enumerateChildNodes(withName: "//grid*") { (node, stop) in
            if let node = node as? SKSpriteNode { node.removeAllChildren() }
        }
    }
}
