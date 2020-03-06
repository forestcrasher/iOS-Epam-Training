//
//  SearchPresenter.swift
//  Practice2
//
//  Created by Anton Pryakhin on 03.03.2020.
//

import Foundation

protocol SearchViewProtocol: class {
    func updateResults()
    func clearResults()
    func updateRecents()
    func handleError(error: Error)
}

protocol SearchViewPresenterProtocol: class {
    var recents: Set<Person> { get set }
    var results: [Person]? { get set }
    
    func clearResults()
    func searchPerson(name: String)
    func tapOnPerson(person: Person?)
    func deleteRecent(person: Person)
    
    init(view: SearchViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
}

class SearchPresenter: SearchViewPresenterProtocol {
    private weak var view: SearchViewProtocol?
    private let networkService: NetworkServiceProtocol!
    private let router: RouterProtocol
    var recents = Set<Person>()
    var results: [Person]?
    
    func clearResults() {
        results = nil
        view?.clearResults()
    }
    
    func searchPerson(name: String) {
        clearResults()
        networkService.searchPerson(name: name) { [weak self] result in
            switch result {
            case .success(let results):
                self?.results = results
                self?.view?.updateResults()
            case .failure(let error):
                self?.view?.handleError(error: error)
            }
        }
    }
    
    func tapOnPerson(person: Person?) {
        if let person = person {
            recents.insert(person)
            view?.updateRecents()
        }
        router.showDetail(person: person)
    }
    
    func deleteRecent(person: Person) {
        recents.remove(person)
    }
    
    required init(view: SearchViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
}
