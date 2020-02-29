//
//  Model.swift
//  Practice1
//
//  Created by Anton Pryakhin on 28.02.2020.
//

import Foundation

enum Progress {
    case guessed
    case high
    case lower
}

struct MainModel {
    private(set) var progress: Progress?
    private(set) var moveCounter = 0
    private(set) var fromRandomNumber: Int?
    private(set) var toRandomNumber: Int?
    private var randomNumber: Int?
    
    private mutating func setRandomNumber() {
        if let from = fromRandomNumber, let to = toRandomNumber {
            if from == to, from > to {
                randomNumber = from
            } else {
                randomNumber = Int.random(in: from...to)
            }
        } else {
            randomNumber = 0
        }
    }
    
    mutating func start() {
        progress = nil
        moveCounter = 0
        setRandomNumber()
    }
    
    mutating func checkAnswer(number: Int) {
        guard let randomNumber = randomNumber else { return }
        
        if number > randomNumber {
            progress = .high
        } else if number < randomNumber {
            progress = .lower
        } else {
            progress = .guessed
        }
        
        moveCounter += 1
    }
    
    mutating func setRandomRange(from: Int, to: Int) {
        fromRandomNumber = from
        toRandomNumber = to
        start()
    }
    
    init(fromRandomNumber: Int, toRandomNumber: Int) {
        self.fromRandomNumber = fromRandomNumber
        self.toRandomNumber = toRandomNumber
        start()
    }
}
