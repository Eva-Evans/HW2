//
//  ContentView.swift
//  MathGame
//  Created by brfsu on 21.02.2022.
//
import SwiftUI

struct ContentView: View {
    @State private var correctAnswer = 0
    @State private var choiceArray: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var difficulty = 100
    @State private var score = 0
    
    var body: some View {
        VStack {
            Text("\(firstNumber) + \(secondNumber)")
                .font(.largeTitle)
                .bold()
            
            // 3x3 Grid
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { col in
                        let index = row * 3 + col
                        Button {
                            answerIsCorrect(answer: choiceArray[index])
                            generateAnswers()
                        } label: {
                            AnswerButton(number: choiceArray[index])
                        }
                    }
                }
            }

            Text("Score: \(score)")
                .font(.headline)
                .bold()
        }.onAppear(perform: generateAnswers)
    }
    
    func answerIsCorrect(answer: Int) {
        let isCorrect = answer == correctAnswer ? true : false
        if isCorrect {
            self.score += 1
        } else {
            self.score -= 1
        }
    }
    
    func generateAnswers() {
        firstNumber = Int.random(in: 0...(difficulty/2))
        secondNumber = Int.random(in: 0...(difficulty/2))
        var answerList = [Int]()
        
        correctAnswer = firstNumber + secondNumber
        
        for _ in 0..<8 {
            answerList.append(Int.random(in: 0...difficulty))
        }
        answerList.append(correctAnswer)
        choiceArray = answerList.shuffled()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
