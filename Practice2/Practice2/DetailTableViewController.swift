//
//  DetailTableViewController.swift
//  Practice2
//
//  Created by Anton Pryakhin on 16.02.2020.
//

import UIKit

class DetailTableViewController: UITableViewController {
    var selected: AnyObject?
    
    var infoKeys = [
        (key: "name", title: "Name"),
        (key: "gender", title: "Gender"),
        (key: "birth_year", title: "Birth Year"),
        (key: "eye_color", title: "Eye Color"),
        (key: "hair_color", title: "Hair Color"),
        (key: "skin_color", title: "Skin Color"),
        (key: "height", title: "Height"),
        (key: "mass", title: "Mass"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoKeys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableCell", for: indexPath)
        cell.textLabel?.text = infoKeys[indexPath.row].title
        if let selected = selected {
            cell.detailTextLabel?.text = selected[infoKeys[indexPath.row].key] as? String
        }
        return cell
    }
}
