//
//  DetailViewController.swift
//  Practice2
//
//  Created by Anton Pryakhin on 03.03.2020.
//

import UIKit

class DetailViewController: UITableViewController {
    var presenter: DetailViewPresenterProtocol!
    var details: [(title: String, value: String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let person = presenter.person {
            title = person.name
            
            details = [
                ("Height", person.height),
                ("Mass", person.mass),
                ("Hair color", person.hairColor),
                ("Skin color", person.skinColor),
                ("Eye color", person.eyeColor),
                ("Birth year", person.birthYear),
                ("Gender", person.gender)
            ]
        }
        
        tableView.allowsSelection = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
                return UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
            }
            return cell
        }()
        
        cell.textLabel?.text = details?[indexPath.row].title
        cell.detailTextLabel?.text = details?[indexPath.row].value
        return cell
    }
}

extension DetailViewController: DetailViewProtocol {

}
