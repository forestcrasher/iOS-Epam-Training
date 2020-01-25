//
//  ViewController.swift
//  Practice1
//
//  Created by Anton Pryakhin on 21.01.2020.
//

import UIKit

class ViewController: UIViewController {
    var randomNumber = 0
    var isWinner = false

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }
    
    func startGame() {
        setRandomNumber()
        checkButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    func stopGame() {
        statusLabel.text = "Угадал"
        checkButton.setTitle("Заново", for: .normal)
        answerField.isUserInteractionEnabled = false
        isWinner = true
    }
    
    func restartGame() {
        setRandomNumber()
        statusLabel.text = ""
        checkButton.setTitle("Проверить", for: .normal)
        answerField.isUserInteractionEnabled = true
        isWinner = false
    }
    
    func setRandomNumber() {
        randomNumber = Int.random(in: 0 ..< 100)
    }
    
    func checkAnswer() {
        if let answer = answerField.text {
            if let answerNumber = Int(answer) {
                if answerNumber > randomNumber {
                    statusLabel.text = "Много"
                } else if answerNumber < randomNumber {
                    statusLabel.text = "Мало"
                } else {
                    stopGame()
                }
            } else {
                statusLabel.text = "Введите число"
            }
        }
    }
    
    @IBAction func buttonAction() {
        if isWinner {
            restartGame()
        } else {
            checkAnswer()
        }
    }
}

