//
//  EndGame.swift
//  TikiTacToe
//
//  Created by Pro on 27.01.2021.
//

import GameplayKit

class GameEnding: GKState {
    
    weak var scene: GameScene?
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool { return stateClass == GameStarting.self }
    
    override func didEnter(from previousState: GKState?) { updGameState() }
    
    func updGameState() {
        let resetNode = self.scene?.childNode(withName: Consts.restart)
        resetNode?.isHidden = false
        resetNode?.run(SKAction.fadeAlpha(to: 1.0, duration: 1.0))
    }
}
