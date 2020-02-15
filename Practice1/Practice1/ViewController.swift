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
    
    private enum Constants {
        static let labelGuessed = "Угадал"
        static let labelMany = "Много"
        static let labelLittle = "Мало"
        static let labelEnterNumber = "Введите число"
        static let buttonLabelCheck = "Проверить"
        static let buttonLabelStartAgain = "Повторить"
    }

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }
    
    func startGame() {
        setRandomNumber()
    }
    
    func stopGame() {
        statusLabel.text = Constants.labelGuessed
        checkButton.setTitle(Constants.buttonLabelStartAgain, for: .normal)
        answerField.isUserInteractionEnabled = false
        isWinner = true
    }
    
    func restartGame() {
        setRandomNumber()
        
        statusLabel.text = ""
        checkButton.setTitle(Constants.buttonLabelCheck, for: .normal)
        answerField.text = ""
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
                    statusLabel.text = Constants.labelMany
                } else if answerNumber < randomNumber {
                    statusLabel.text = Constants.labelLittle
                } else {
                    stopGame()
                }
            } else {
                statusLabel.text = Constants.labelEnterNumber
            }
        }
    }
    
    @IBAction func buttonAction() {
        isWinner ? restartGame() : checkAnswer()
    }
}

