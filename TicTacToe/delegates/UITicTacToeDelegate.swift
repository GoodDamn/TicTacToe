//
//  UITicTacToeDelegate.swift
//  TicTacToe
//
//  Created by Cell on 06.05.2023.
//

import Foundation
protocol UITicTacToeDelegate {
    
    func onCrossPlayerWins()
    
    func onCirclePlayerWins()
    
    func onDraw()
    
    func onEndGameSession()
    
}
