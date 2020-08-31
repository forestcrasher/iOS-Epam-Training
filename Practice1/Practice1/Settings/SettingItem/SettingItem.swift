//
//  SettingItem.swift
//  Practice1
//
//  Created by Anton Pryakhin on 29.02.2020.
//

import UIKit

class SettingItem: UITableViewCell {
    var changeSettingItemValueToModel: ((String) -> Void)?
    
    @IBOutlet weak var settingTitle: UILabel!
    @IBOutlet weak var settingValue: UITextField!
    
    @IBAction func settingValueEditingChanged(_ sender: UITextField) {
        changeSettingItemValueToModel?(sender.text ?? "0")
    }
}
