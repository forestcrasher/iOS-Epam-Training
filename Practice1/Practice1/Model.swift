//
//  Model.swift
//  Practice1
//
//  Created by Антон Пряхин on 28.02.2020.
//  Copyright © 2020 Антон Пряхин. All rights reserved.
//

import Foundation

enum Progress {
    case guessed
    case high
    case lower
}

struct Model {
    private(set) var progress: Progress?
    private var randomNumber: Int?
    
    mutating func start() {
        progress = nil
        randomNumber = Int.random(in: 0..<100)
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
    }
    
    init() {
        start()
    }
}
