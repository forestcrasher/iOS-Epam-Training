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
    private var recents = [Person]()
   
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Star Wars"
        
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .systemGroupedBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "SearchTableViewCell")
        
        hideError()
    }
    
    private func showError(text: String) {
        error.text = text
        error.isHidden = false
    }
    
    private func hideError() {
        error.text = ""
        error.isHidden = true
    }
}

extension SearchViewController: SearchViewProtocol {
    func updateResults() {
        DispatchQueue.main.async { [weak self] in
            self?.loader.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    func clearResults() {
        DispatchQueue.main.async { [weak self] in
            self?.hideError()
            self?.tableView.reloadData()
        }
    }
    
    func updateRecents() {
        recents = Array(presenter.recents)
    }
    
    func handleError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.loader.stopAnimating()
            if let text = (error as NSError).userInfo["NSLocalizedDescription"] as? String {
                self?.showError(text: text)
            }
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let results = presenter.results {
            let person = results[indexPath.row]
            presenter.tapOnPerson(person: person)
        } else {
            let person = recents[indexPath.row]
            presenter.tapOnPerson(person: person)
        }
        searchBar.searchTextField.resignFirstResponder()
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if presenter.results != nil {
            return .none
        } else {
            return .delete
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if presenter.results != nil {
            return 1
        } else {
            return !recents.isEmpty ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if let results = presenter.results {
                return !results.isEmpty ? "Search" : nil
            } else {
                return !recents.isEmpty ? "Recents" : nil
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = presenter.results else {
            return recents.count
        }
        
        if results.isEmpty {
            showError(text: "People not found")
        }
        
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell {
            guard let results = presenter.results else {
                cell.labelText?.text = recents[indexPath.row].name
                cell.sublabelText?.text = "Character"
                return cell
            }
            
            cell.labelText?.text = results[indexPath.row].name
            cell.sublabelText?.text = "Character"
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
          return .none
     }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if presenter.results != nil { return }
        if editingStyle == .delete {
            presenter.deleteRecent(person: recents[indexPath.row])
            recents.remove(at: indexPath.row)
            if recents.isEmpty {
                clearResults()
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
