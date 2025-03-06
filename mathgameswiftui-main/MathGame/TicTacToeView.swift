//
//  TicTacToeView.swift
//  MathGame
//
//  Created by Александр Иванов on 06.03.2025.
//
import SwiftUI


struct TicTacToeView: View {
    @State private var board = Array(repeating: "", count: 9)
    @State private var currentPlayer = "X"
    @State private var gameOver = false
    @State private var winner = ""
    @State private var isAgainstComputer = false
    
    var body: some View {
        VStack {
            Text("Крестики-нолики")
                .font(.largeTitle)
                .bold()
            
            if !gameOver {
                Picker("Режим игры", selection: $isAgainstComputer) {
                    Text("2 игрока").tag(false)
                    Text("Против компьютера").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            
            // 3x3 Grid
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { col in
                        let index = row * 3 + col
                        Button(action: {
                            if board[index] == "" && !gameOver {
                                board[index] = currentPlayer
                                checkForWinner()
                                if !gameOver && isAgainstComputer && currentPlayer == "X" {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        computerMove()
                                    }
                                }
                                currentPlayer = currentPlayer == "X" ? "O" : "X"
                            }
                        }) {
                            Text(board[index])
                                .font(.system(size: 40, weight: .bold))
                                .frame(width: 80, height: 80)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            
            if gameOver {
                Text(winner == "" ? "Ничья!" : "Победитель: \(winner)")
                    .font(.title)
                    .padding()
                
                Button("Начать заново") {
                    resetGame()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
    
    func checkForWinner() {
        let winningCombinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6] // Diagonals
        ]
        
        for combo in winningCombinations {
            if board[combo[0]] != "" && board[combo[0]] == board[combo[1]] && board[combo[1]] == board[combo[2]] {
                winner = board[combo[0]]
                gameOver = true
                return
            }
        }
        
        if !board.contains("") {
            gameOver = true
        }
    }
    
    func resetGame() {
        board = Array(repeating: "", count: 9)
        currentPlayer = "X"
        gameOver = false
        winner = ""
    }
    
    func computerMove() {
        var bestScore = Int.min
        var bestMove = -1
        
        for i in 0..<9 {
            if board[i] == "" {
                board[i] = "O"
                let score = minimax(board: board, isMaximizing: false)
                board[i] = ""
                
                if score > bestScore {
                    bestScore = score
                    bestMove = i
                }
            }
        }
        
        if bestMove != -1 {
            board[bestMove] = "O"
            checkForWinner()
            currentPlayer = "X"
        }
    }
    
    func minimax(board: [String], isMaximizing: Bool) -> Int {
        let result = checkGameResult(board)
        if result != "" {
            return result == "O" ? 1 : (result == "X" ? -1 : 0)
        }
        
        if isMaximizing {
            var bestScore = Int.min
            for i in 0..<9 {
                if board[i] == "" {
                    var newBoard = board
                    newBoard[i] = "O"
                    let score = minimax(board: newBoard, isMaximizing: false)
                    bestScore = max(score, bestScore)
                }
            }
            return bestScore
        } else {
            var bestScore = Int.max
            for i in 0..<9 {
                if board[i] == "" {
                    var newBoard = board
                    newBoard[i] = "X"
                    let score = minimax(board: newBoard, isMaximizing: true)
                    bestScore = min(score, bestScore)
                }
            }
            return bestScore
        }
    }
    
    func checkGameResult(_ board: [String]) -> String {
        let winningCombinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6] // Diagonals
        ]
        
        for combo in winningCombinations {
            if board[combo[0]] != "" && board[combo[0]] == board[combo[1]] && board[combo[1]] == board[combo[2]] {
                return board[combo[0]]
            }
        }
        
        if !board.contains("") {
            return "Draw"
        }
        
        return ""
    }
}

struct TicTacToeView_Previews: PreviewProvider {
    static var previews: some View {
        TicTacToeView()
    }
}
