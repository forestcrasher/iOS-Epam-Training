//
//  StatisticsViewController.swift
//  Practice1
//
//  Created by Anton Pryakhin on 29.02.2020.
//

import UIKit

class StatisticsViewController: UITableViewController {
    var moveCounter = 0
    var sessionGameCounter = 0
    
    private var list: [(title: String, value: String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = [
            (title: NSLocalizedString("statisticMoveCounter", comment: ""), value: String(moveCounter)),
            (title: NSLocalizedString("statisticSessionGameCounter", comment: ""), value: String(sessionGameCounter)),
        ]
        
        title = NSLocalizedString("statisticsTitle", comment: "")
        navigationItem.largeTitleDisplayMode = .never
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticItem", for: indexPath)
        cell.textLabel?.text = list?[indexPath.row].title
        cell.detailTextLabel?.text = list?[indexPath.row].value
        return cell
    }
}
