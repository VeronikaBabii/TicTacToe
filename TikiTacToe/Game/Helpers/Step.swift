//
//  Move.swift
//  TikiTacToe
//
//  Created by Pro on 15.02.2021.
//

import GameplayKit

@objc(Move)
class Step: NSObject, GKGameModelUpdate {
    
    var value: Int = 0
    
    var cell: Int
    
    init(cell: Int) {
        self.cell = cell
        super.init()
    }
}
