//
//  GameViewController.swift
//  Practice1
//
//  Created by Anton Pryakhin on 21.01.2020.
//

import UIKit

class GameViewController: UIViewController {
    private var game: GameModel?
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var moveCounter: UILabel!
    
    @IBAction private func touchCheck() {
        if let answer = textField.text, let number = Int(answer) {
            game?.checkAnswer(number: number)
            updateViewFromModel()
        } else {
            showAlert(
                title: NSLocalizedString("alertEnterNumber", comment: ""),
                message: NSLocalizedString("alertEnterNumberDescription", comment: ""),
                actionTitle: NSLocalizedString("alertActionAgain", comment: "")
            )
        }
    }
    
    @objc private func touchSettings() {
        if let vc = storyboard?.instantiateViewController(identifier: "Settings") as? SettingsViewController {
            vc.from = game?.fromRandomNumber ?? 0
            vc.to = game?.toRandomNumber ?? 0
            vc.pullRandomRangeForParent = { [weak self] from, to in
                UserDefaults.standard.set(from, forKey: "fromRandomNumber")
                UserDefaults.standard.set(to, forKey: "toRandomNumber")
                self?.game?.setRandomRange(from: from, to: to)
                self?.updateControls()
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func touchStats() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fromRandomNumber = UserDefaults.standard.integer(forKey: "fromRandomNumber")
        let toRandomNumber = UserDefaults.standard.integer(forKey: "toRandomNumber")
        
        if fromRandomNumber == 0 && toRandomNumber == 0 {
            textField.isEnabled = false
            checkButton.isEnabled = false
            
            showAlert(
                title: NSLocalizedString("alertSetRandomRange", comment: ""),
                message: NSLocalizedString("alertSetRandomRangeDescription", comment: ""),
                actionTitle: NSLocalizedString("alertActionOK", comment: "")
            ) { [weak self] _ in
                self?.touchSettings()
            }
        }
        
        game = GameModel(fromRandomNumber: fromRandomNumber, toRandomNumber: toRandomNumber)
        
        title = NSLocalizedString("mainTitle", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 25
        
        let customSettingsButton = UIButton(type: .custom)
        customSettingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        customSettingsButton.imageView?.contentMode = .scaleAspectFit
        customSettingsButton.imageEdgeInsets = UIEdgeInsets(top: 26, left: 26, bottom: 26, right: 26)
        customSettingsButton.addTarget(self, action: #selector(touchSettings), for: .touchDown)
        let settings = UIBarButtonItem(customView: customSettingsButton)
        
        let customStatsButton = UIButton(type: .custom)
        customStatsButton.setImage(UIImage(systemName: "chart.pie.fill"), for: .normal)
        customStatsButton.imageView?.contentMode = .scaleAspectFit
        customStatsButton.imageEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        customStatsButton.addTarget(self, action: #selector(touchStats), for: .touchDown)
        let stats = UIBarButtonItem(customView: customStatsButton)
        
        navigationItem.rightBarButtonItems = [settings, spacer, stats]
        
        textField.placeholder = NSLocalizedString("textFieldPlaceholder", comment: "")
        checkButton.setTitle(NSLocalizedString("checkButtonTitle", comment: ""), for: .normal)
        moveCounter.text = "\(NSLocalizedString("moveCounterTitle", comment: "")): \(game?.moveCounter ?? 0)"
    }
    
    private func updateViewFromModel() {
        guard let progress = game?.progress else { return }
        
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
                    self?.game?.start()
                    self?.updateMoveCounter()
                }
        }
        
        updateMoveCounter()
    }
    
    private func updateMoveCounter() {
        moveCounter.text = "\(NSLocalizedString("moveCounterTitle", comment: "")): \(game?.moveCounter ?? 0)"
    }
    
    private func updateControls() {
        textField.isEnabled = true
        checkButton.isEnabled = true
    }
    
    private func showAlert(title: String?, message: String?, actionTitle: String?, actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: actionHandler))
        present(ac, animated: true)
    }
}
