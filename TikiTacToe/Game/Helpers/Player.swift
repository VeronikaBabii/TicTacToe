//
//  Player.swift
//  TikiTacToe
//
//  Created by Pro on 15.02.2021.
//

import GameplayKit

@objc(Player)
class Player: NSObject, GKGameModelPlayer {
    
    let _player: Int
    
    var playerId: Int { return _player }
    
    init(player:Int) {
        _player = player
        super.init()
    }
}
