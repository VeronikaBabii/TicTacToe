//
//  GameScene.swift
//  TikiTacToe
//
//  Created by Pro on 27.01.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var level: Int!
    
    var gameBoard: Grid!
    var stateMachine: GKStateMachine!
    var AI: GKMinmaxStrategist!
    
    var soundAction: SKAction!
    var soundAction1: SKAction!
    var soundAction2: SKAction!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        fullSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let selectedNode = self.atPoint(location)
            var node: SKSpriteNode
            
            // if restart button is pressed
            if let name = selectedNode.name {
                if name == Consts.restart {
                    
                    let currCompleted = UserDefaults.standard.integer(forKey: "completedLevel")
                    print("curr completed - \(currCompleted)")
                    UserDefaults.standard.setValue(currCompleted - 1, forKey: "completedLevel")
                    
                    UserDefaults.standard.setValue(1, forKey: "restarted")
                    
                    self.stateMachine.enter(GameStarting.self)
                    print("restart level")
                    return
                }
            }
            
            let imgSize = CGSize(width: Consts.cellSize + 40, height: Consts.cellSize + 40)
            
            if gameBoard.isPlayer1() {
                let xx = SKSpriteNode(imageNamed: Consts.xCell)
                xx.size = imgSize
                node = xx
            } else {
                let oo = SKSpriteNode(imageNamed: Consts.oCell)
                oo.size = imgSize
                node = oo
            }
            
            node.alpha = 0.0
            let show = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
            node.run(show)
            
            for pos in 0 ... 8 {
                guard let cellNode: SKSpriteNode = self.childNode(withName: gameBoard.getElemAtBoardLocation(pos).node) as? SKSpriteNode else { return }
                
                if selectedNode.name == cellNode.name {
                    cellNode.addChild(node)
                    gameBoard.addPlayerValueAtBoardLocation(pos, value: gameBoard.isPlayer1() ? .x : .o)
                    gameBoard.togglePlayer()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) { stateMachine.update(deltaTime: currentTime) }
}

extension GameScene {
    
    func fullSetup() {
        // set grid
        self.enumerateChildNodes(withName: Consts.searchGrid) { (node, stop) in
            if let node = node as? SKSpriteNode { node.color = UIColor.clear }
        }
        
        // set ai
        AI = GKMinmaxStrategist()
        AI.randomSource = GKARC4RandomSource()
        
        turnsAIthinkOf(lvl: level)
        setupStates()
    }
    
    func setupStates() {
        let startGameState = GameStarting(scene: self)
        let activeGameState = GamePlaying(scene: self)
        let endGameState = GameEnding(scene: self)
        
        stateMachine = GKStateMachine(states: [startGameState, activeGameState, endGameState])
        stateMachine.enter(GameStarting.self)
    }
    
    // The number of future turns for the strategist to consider when planning moves = maxLookAheadDepth
    func turnsAIthinkOf(lvl: Int) {
        
        func depthToLevel(_ level: Int) -> DiffLevel {
            
            let diffNode = self.childNode(withName: "difScale") as? SKSpriteNode
            
            switch level {
            case 1:
                diffNode?.texture = SKTexture(imageNamed: "dif1")
                return .one
            case 2:
                diffNode?.texture = SKTexture(imageNamed: "dif2")
                return .two
            case 3:
                diffNode?.texture = SKTexture(imageNamed: "dif3")
                return .three
            case 4:
                diffNode?.texture = SKTexture(imageNamed: "dif4")
                return .four
            case 5:
                diffNode?.texture = SKTexture(imageNamed: "dif5")
                return .five
            case 6:
                diffNode?.texture = SKTexture(imageNamed: "dif6")
                return .six
            case 7:
                diffNode?.texture = SKTexture(imageNamed: "dif7")
                return .seven
            case 8:
                diffNode?.texture = SKTexture(imageNamed: "dif8")
                return .eight
            case 9:
                diffNode?.texture = SKTexture(imageNamed: "dif9")
                return .nine
            default:
                diffNode?.texture = SKTexture(imageNamed: "dif1")
                return .idol
            }
        }
        
        AI.maxLookAheadDepth = lvl
        
        guard let diffLabelNode = self.childNode(withName: "difficultyLevel") as? SKLabelNode
        else {
            print("No difficultyLevel on board")
            return()
        }
        
        diffLabelNode.text = "Difficulty: \(depthToLevel(lvl).rawValue)"
    }
    
    func humanOrAI() -> CurrentPlayer { return drand48() >= 0.5 ? .human : .ai }
}
