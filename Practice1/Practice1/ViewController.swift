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
            showAlert(title: "Введите число", message: "Поле не должно быть пустым!", actionTitle: "Еще раз")
        }
    }
    
    private func updateViewFromModel() {
        guard let progress = game.progress else { return }
        
        switch progress {
            case .high:
                showAlert(title: "Слишком много", message: "Вы ввели слишком большое число!", actionTitle: "Еще раз")
    
            case .lower:
                showAlert(title: "Слишком мало", message: "Вы ввели слишком маленькое число!", actionTitle: "Еще раз")
            
            case .guessed:
                showAlert(title: "Вы угадали", message: "Вы попали в точку!", actionTitle: "Играть заново") { [weak self] _ in
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
        
        title = "Угадай число"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        textField.placeholder = "Введите число"
        button.setTitle("Проверить", for: .normal)
    }
}
