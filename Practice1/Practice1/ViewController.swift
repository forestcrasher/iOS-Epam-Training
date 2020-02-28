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
    @IBOutlet private weak var button: UIButton!
    
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
                }
        }
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
        button.setTitle(NSLocalizedString("buttonTitle", comment: ""), for: .normal)
    }
}
