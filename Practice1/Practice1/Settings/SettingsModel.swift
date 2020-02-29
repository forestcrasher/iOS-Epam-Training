//
//  SettingsModel.swift
//  Practice1
//
//  Created by Anton Pryakhin on 29.02.2020.
//

import Foundation

typealias Setting = (title: String, value: String, key: String)

struct SettingsModel {
    private(set) var list = [Setting]()
    
    mutating func setValue(value: String, at index: Int) {
        list[index].value = value
    }
    
    func getValue(by key: String) -> String? {
        guard let index = list.firstIndex(where: { $0.key == key }) else { return nil }
        return list[index].value
    }
    
    init(list: [Setting]) {
        self.list = list
    }
}
