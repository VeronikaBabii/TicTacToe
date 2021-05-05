//
//  Structs.swift
//  TikiTacToe
//
//  Created by Pro on 28.01.2021.
//

import Foundation

struct Consts {
    static let cellSize = 148
    static let oCell = "O"
    static let xCell = "X"
    static let restart = "restart"
    static let searchGrid = "//grid*"
    static let difficulty = "Difficulty:"
    
    // levels names
    static let level1 = "1LevelSpriteNode"
    static let level2 = "2LevelSpriteNode"
    static let level3 = "3LevelSpriteNode"
    static let level4 = "4LevelSpriteNode"
    static let level5 = "5LevelSpriteNode"
    static let level6 = "6LevelSpriteNode"
    static let level7 = "7LevelSpriteNode"
    static let level8 = "8LevelSpriteNode"
    static let level9 = "9LevelSpriteNode"
}

// 9 maxlooksahead = 9 levels of difficulty
enum DiffLevel: String {
    case one = "Stone Idol"
    case two = "Fish Princess"
    case three = "Bull Idol"
    case four = "Tiger Idol"
    case five = "Jungle Monkey"
    case six = "Fire Human"
    case seven = "Dragon God"
    case eight = "Goat God"
    case nine = "Tiki Idol"
    case idol = "Idol" // default
}

enum CurrentPlayer: Int {
    case human = 0
    case ai = 1
}

enum PlayerType: Int {
    case x
    case o
    case none
}

enum GameState: Int {
    case winner
    case draw
    case playing
}

struct BoardCell {
    var value: PlayerType
    var node: String
}
