//
//  SearchViewController.swift
//  Practice2
//
//  Created by Anton Pryakhin on 03.03.2020.
//

import UIKit

class SearchViewController: UIViewController {
    var presenter: SearchViewPresenterProtocol!
    
    private var pendingRequestWorkItem: DispatchWorkItem?
   
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Star Wars"
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .systemGroupedBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "SearchTableViewCell")
        
        hideError()
    }
    
    func showError(text: String) {
        error.text = text
        error.isHidden = false
    }
    
    func hideError() {
        error.text = ""
        error.isHidden = true
    }
}

extension SearchViewController: SearchViewProtocol {
    func updateResults() {
        hideError()
        loader.stopAnimating()
        tableView.reloadData()
    }
    
    func handleError(error: Error) {
        loader.stopAnimating()
        
        if let text = (error as NSError).userInfo["NSLocalizedDescription"] as? String {
            showError(text: text)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()
        
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedSearchText.isEmpty {
            presenter.clearResults()
            return
        }
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.pendingRequestWorkItem = nil
            self?.presenter.searchPerson(name: trimmedSearchText)
            self?.loader.startAnimating()
        }
        
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: requestWorkItem)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = presenter.results?[indexPath.row]
        presenter.tapOnPerson(person: person)
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.results != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let isRecents = presenter.isRecents else { return nil }
        
        if section == 0 && !(presenter.results?.isEmpty ?? true) {
            return isRecents ? "Recents" : "Search"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = presenter.results else { return 0 }
        
        if results.isEmpty {
            showError(text: "People not found")
        }
        
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell {
            cell.labelText?.text = presenter.results?[indexPath.row].name
            cell.sublabelText?.text = "Character"
            return cell
        }
        
        return UITableViewCell()
    }
}
