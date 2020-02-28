//
//  ViewController.swift
//  Practice1
//
//  Created by Anton Pryakhin on 21.01.2020.
//

import UIKit

class ViewController: UIViewController {
    private var game = Model()
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet weak var moveCounter: UILabel!
    
    @IBAction private func touchCheck() {
        if let answer = textField.text, let number = Int(answer) {
            game.checkAnswer(number: number)
            updateViewFromModel()
        } else {
            showAlert(
                title: NSLocalizedString("alertEnterNumber", comment: ""),
                message: NSLocalizedString("alertEnterNumberDescription", comment: ""),
                actionTitle: NSLocalizedString("alertActionAgain", comment: "")
            )
        }
    }
    
    private func updateViewFromModel() {
        guard let progress = game.progress else { return }
        
        switch progress {
            case .high:
                showAlert(
                    title: NSLocalizedString("alertTooHigh", comment: ""),
                    message: NSLocalizedString("alertTooHighDescription", comment: ""),
                    actionTitle: NSLocalizedString("alertActionAgain", comment: "")
                )
    
            case .lower:
                showAlert(
                    title: NSLocalizedString("alertTooLower", comment: ""),
                    message: NSLocalizedString("alertTooLowerDescription", comment: ""),
                    actionTitle: NSLocalizedString("alertActionAgain", comment: "")
                )
            
            case .guessed:
                showAlert(
                    title: NSLocalizedString("alertYouGuessed", comment: ""),
                    message: NSLocalizedString("alertYouGuessedDescription", comment: ""),
                    actionTitle: NSLocalizedString("alertActionPlayAgain", comment: "")
                ) { [weak self] _ in
                    self?.textField.text = ""
                    self?.game.start()
                    self?.updateMoveCounter()
                }
        }
        
        updateMoveCounter()
    }
    
    private func updateMoveCounter() {
        moveCounter.text = "\(NSLocalizedString("moveCounterTitle", comment: "")): \(game.moveCounter)"
    }
    
    private func showAlert(title: String?, message: String?, actionTitle: String?, actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: actionHandler))
        present(ac, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("mainTitle", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        textField.placeholder = NSLocalizedString("textFieldPlaceholder", comment: "")
        checkButton.setTitle(NSLocalizedString("checkButtonTitle", comment: ""), for: .normal)
        moveCounter.text = "\(NSLocalizedString("moveCounterTitle", comment: "")): \(game.moveCounter)"
    }
}
