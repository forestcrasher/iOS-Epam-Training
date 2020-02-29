//
//  SettingsViewController.swift
//  Practice1
//
//  Created by Anton Pryakhin on 29.02.2020.
//

import UIKit

class SettingsViewController: UITableViewController {
    var pullRandomRangeForParent: ((_ from: Int, _ to: Int) -> Void)?
    var from = 0
    var to = 0
    
    private var settings: SettingsModel?
    private var saveButton: UIButton?
    
    @objc private func saveSettings() {
        if let fromValue = settings?.getValue(by: "from"), let toValue = settings?.getValue(by: "to"),
            let from = Int(fromValue), let to = Int(toValue)  {
            
            if to > from {
                pullRandomRangeForParent?(from, to)
                navigationController?.popToRootViewController(animated: true)
            } else if to < from {
                showAlert(
                    title: NSLocalizedString("alertFieldsNotFilledCorrectly", comment: ""),
                    message: NSLocalizedString("alertFromMoreToDescription", comment: ""),
                    actionTitle: NSLocalizedString("alertActionOK", comment: "")
                )
            } else {
                showAlert(
                    title: NSLocalizedString("alertFieldsNotFilledCorrectly", comment: ""),
                    message: NSLocalizedString("alertFromEqualToDescription", comment: ""),
                    actionTitle: NSLocalizedString("alertActionOK", comment: "")
                )
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings = SettingsModel(list: [
            (title: NSLocalizedString("settingFromNumber", comment: ""), value: String(from), key: "from"),
            (title: NSLocalizedString("settingToNumber", comment: ""), value: String(to), key: "to"),
        ])
        
        saveButton = UIButton(type: .custom)
        
        if let saveButton = saveButton {
            saveButton.setTitle(NSLocalizedString("saveButtonTitle", comment: ""), for: .normal)
            saveButton.setTitleColor(.systemBlue, for: .normal)
            saveButton.setTitleColor(.systemGray, for: .disabled)
            saveButton.addTarget(self, action: #selector(saveSettings), for: .touchDown)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        }
        
        title = NSLocalizedString("settingsTitle", comment: "")
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.register(UINib(nibName: "SettingItem", bundle: nil), forCellReuseIdentifier: "SettingItem")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return NSLocalizedString("settingsTitleSectionRandomNumberRange", comment: "")
            default: return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings?.list.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingItem", for: indexPath) as! SettingItem
        cell.settingTitle?.text = settings?.list[indexPath.row].title
        cell.settingValue?.text = settings?.list[indexPath.row].value
        cell.changeSettingItemValueToModel = { [weak self] value in
            self?.saveButton?.isEnabled = Bool(value != "")
            self?.settings?.setValue(value: value, at: indexPath.row)
        }
        return cell
    }
    
    private func showAlert(title: String?, message: String?, actionTitle: String?, actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: actionHandler))
        present(ac, animated: true)
    }
}
