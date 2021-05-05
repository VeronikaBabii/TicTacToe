//
//  Gameplay.swift
//  TikiTacToe
//
//  Created by Pro on 27.01.2021.
//

import GameplayKit

// MARK: -
@objc(Board)
class Grid: NSObject, NSCopying, GKGameModel {
    
    fileprivate let _players: [GKGameModelPlayer] = [Player(player: 0), Player(player: 1)]
    fileprivate var currPlayer: GKGameModelPlayer?
    fileprivate var grid: [BoardCell]
    fileprivate var player1currScore: Int
    fileprivate var player2currScore: Int
    
    var activePlayer: GKGameModelPlayer? { return currPlayer }
    
    func isPlayer1() -> Bool { return currPlayer?.playerId == _players[0].playerId }
    
    func getPlayer1() -> GKGameModelPlayer { return _players[0] }
    func getPlayer2() -> GKGameModelPlayer { return _players[1] }
    
    func isPlayer1Turn() -> Bool { return isPlayer1(activePlayer!) }
    @objc func isPlayer1(_ player: GKGameModelPlayer) -> Bool { return player.playerId == _players[0].playerId }
    func isPlayer2Turn() -> Bool { return !isPlayer1Turn() }
    
    func getElemAtBoardLocation(_ index: Int) -> BoardCell { return grid[index] }
    
    func addPlayerValueAtBoardLocation(_ index: Int, value: PlayerType) { grid[index].value = value }
    
    @objc func copy(with zone: NSZone?) -> Any { // for protocol confrontation
        let copy = Grid()
        copy.setGameModel(self)
        return copy
    }
    
    required override init() {
        self.currPlayer = _players[0]
        self.grid = []
        self.player1currScore = 0
        self.player2currScore = 0
        super.init()
    }
    
    init(gameboard: [BoardCell], currentPlayer: CurrentPlayer = .human) {
        self.currPlayer = _players[currentPlayer.rawValue]
        self.grid = gameboard
        self.player1currScore = 0
        self.player2currScore = 0
        super.init()
    }
    
    required init(_ board: Grid) {
        self.currPlayer = board.currPlayer
        self.grid = Array(board.grid)
        self.player1currScore = 0
        self.player2currScore = 0
        super.init()
    }
    
    func togglePlayer() { currPlayer = currPlayer?.playerId == _players[0].playerId ? _players[1] : _players[0] }
    
    func setGameModel(_ gameModel: GKGameModel) {
        if let grid = gameModel as? Grid {
            self.currPlayer = grid.currPlayer
            self.grid = Array(grid.grid)
        }
    }
    
    //
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        var turns: [GKGameModelUpdate] = []
        
        for (index, _) in self.grid.enumerated() {
            if self.grid[index].value == .none { turns.append(Step(cell: index)) }
        }
        return turns
    }
    
    func unapplyGameModelUpdate(_ gameModelUpdate: GKGameModelUpdate) {
        let step = gameModelUpdate as! Step
        self.grid[step.cell].value = .none
        self.togglePlayer()
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        let step = gameModelUpdate as! Step
        self.grid[step.cell].value = isPlayer1() ? .x : .o
        self.togglePlayer()
    }
    
    //
    func getPlayerAtBoardCell(_ gridCoord: BoardCell) -> GKGameModelPlayer? {
        return gridCoord.value == .x ? self.players?.first : self.players?.last
    }
    
    @objc var players: [GKGameModelPlayer]? { return self._players }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        let (state, winner) = checkForWinner()
        if state == .winner && winner?.playerId == player.playerId { return true }
        return false
    }
    
    func isLoss(for player: GKGameModelPlayer) -> Bool {
        let (state, winner) = checkForWinner()
        if state == .winner && winner?.playerId != player.playerId { return true }
        return false
    }
}

// MARK: - score extension
extension Grid {
    func score(for player: GKGameModelPlayer) -> Int {
        
        if isWin(for: player) {
            if isPlayer1(player) {
                player1currScore += 4
                return player1currScore
            } else {
                player2currScore += 4
                return player2currScore
            }
        }
        
        if isLoss(for: player) { return 0 }
        
        let opponent = isPlayer1(player) ? getPlayer2() : getPlayer1()
        
        let opponentMoveAwayFromWin = isMoveAwayFromWin(opponent)
        if opponentMoveAwayFromWin {
            
            if isPlayer1(player) {
                player1currScore += 3
                return player1currScore
            } else {
                player2currScore += 3
                return player2currScore
            }
        }
        
        let playerMoveAwayFromWin = isMoveAwayFromWin(player)
        if playerMoveAwayFromWin {
            
            if isPlayer1(player) {
                player1currScore += 2
                return player1currScore
            } else {
                player2currScore += 2
                return player2currScore
            }
        }
        
        if isPlayer1(player) {
            player1currScore += 1
            return player1currScore
        } else {
            player2currScore += 1
            return player2currScore
        }
    }
}

// MARK: - isMoveAwayFromWin extension
extension Grid {
    func isMoveAwayFromWin(_ player: GKGameModelPlayer) -> Bool {
        
        let diagonalChecker = { (row: ArraySlice<BoardCell>, playerCell: PlayerType) -> Bool in
            
            let playerTypes = row.filter { $0.value == playerCell }
            let blankCells = row.filter { $0.value == .none }
            
            if blankCells.count == 0 { return false }
            if playerTypes.count == 2 { return true }
            
            return false
        }
        
        let row1 = grid[0...2]
        let row2 = grid[3...5]
        let row3 = grid[6...8]
        
        let playerCell: PlayerType = isPlayer1(player) ? .x : .o
        
        if diagonalChecker(row1, playerCell) { return true }
        if diagonalChecker(row2, playerCell) { return true }
        if diagonalChecker(row3, playerCell) { return true }
        
        var col1 = ArraySlice<BoardCell>()
        col1.append(grid[0])
        col1.append(grid[3])
        col1.append(grid[6])
        if diagonalChecker(col1, playerCell) { return true }
        
        var col2 = ArraySlice<BoardCell>()
        col2.append(grid[1])
        col2.append(grid[4])
        col2.append(grid[7])
        if diagonalChecker(col2, playerCell) { return true }
        
        var col3 = ArraySlice<BoardCell>()
        col3.append(grid[2])
        col3.append(grid[5])
        col3.append(grid[8])
        if diagonalChecker(col3, playerCell) { return true }
        
        var diag1 = ArraySlice<BoardCell>()
        diag1.append(grid[0])
        diag1.append(grid[4])
        diag1.append(grid[8])
        if diagonalChecker(diag1, playerCell) { return true }
        
        var diag2 = ArraySlice<BoardCell>()
        diag2.append(grid[2])
        diag2.append(grid[4])
        diag2.append(grid[6])
        if diagonalChecker(diag2, playerCell) { return true }
        
        return false
    }
}

// MARK: - checkForWinner extension
extension Grid {
    func checkForWinner() -> (GameState, GKGameModelPlayer?) {
        
        // check rows
        if grid[0].value != .none && (grid[0].value == grid[1].value
                                        && grid[0].value == grid[2].value) {
            guard let winner: GKGameModelPlayer = getPlayerAtBoardCell(grid[0])
            else { return (.draw, nil) }
            
            return (.winner, winner)
        }
        
        if grid[3].value != .none && (grid[3].value == grid[4].value
                                        && grid[3].value == grid[5].value) {
            guard let winner: GKGameModelPlayer = getPlayerAtBoardCell(grid[3])
            else { return (.draw, nil) }
            
            return (.winner, winner)
        }
        
        if grid[6].value != .none && (grid[6].value == grid[7].value
                                        && grid[6].value == grid[8].value) {
            guard let winner: GKGameModelPlayer = getPlayerAtBoardCell(grid[6])
            else { return (.draw, nil) }
            
            return (.winner, winner)
        }
        
        // check cols
        if grid[0].value != .none && (grid[0].value == grid[3].value
                                        && grid[3].value == grid[6].value) {
            guard let winner: GKGameModelPlayer = getPlayerAtBoardCell(grid[0])
            else { return (.draw, nil) }
            
            return (.winner, winner)
        }
        
        if grid[1].value != .none && (grid[1].value == grid[4].value
                                        && grid[4].value == grid[7].value) {
            guard let winner: GKGameModelPlayer = getPlayerAtBoardCell(grid[1])
            else { return (.draw, nil) }
            
            return (.winner, winner)
        }
        
        if grid[2].value != .none && (grid[2].value == grid[5].value
                                        && grid[5].value == grid[8].value) {
            guard let winner: GKGameModelPlayer = getPlayerAtBoardCell(grid[2])
            else { return (.draw, nil) }
            
            return (.winner, winner)
        }
        
        // check diagonals
        if grid[0].value != .none && (grid[0].value == grid[4].value
                                        && grid[4].value == grid[8].value) {
            guard let winner: GKGameModelPlayer = getPlayerAtBoardCell(grid[0])
            else { return (.draw, nil) }
            
            return (.winner, winner)
        }
        
        if grid[2].value != .none && (grid[2].value == grid[4].value
                                        && grid[4].value == grid[6].value) {
            guard let winner: GKGameModelPlayer = getPlayerAtBoardCell(grid[2])
            else { return (.draw, nil) }
            
            return (.winner, winner)
        }
        
        let foundEmptyCells: [BoardCell] = grid.filter { gridCoord -> Bool in
            return gridCoord.value == .none
        }
        
        if foundEmptyCells.isEmpty { return (.draw, nil) }
        
        return (.playing, nil)
    }
}
