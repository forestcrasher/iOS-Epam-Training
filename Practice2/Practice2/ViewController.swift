//
//  ViewController.swift
//  Practice2
//
//  Created by Anton Pryakhin on 15.02.2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var results: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        
        let searchValue = searchBarText.replacingOccurrences(of: " ", with: "%20")
        let stringUrl = "https://swapi.co/api/people/?search=\(searchValue)"
        
        guard let url = URL(string: stringUrl) else { return }
        
        var results: [AnyObject] = []
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            do {
                guard let data = data else { return }
                
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                
                if let jsonResults = json["results"] as? [AnyObject] {
                    results = jsonResults
                }
                
                DispatchQueue.main.async {
                    self?.results = results
                    self?.tableView.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTableViewController {
            vc.selected = results[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        print(results)
        cell.textLabel?.text = results[indexPath.row]["name"] as? String
        return cell
    }
}
