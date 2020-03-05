//
//  SearchPresenter.swift
//  Practice2
//
//  Created by Anton Pryakhin on 03.03.2020.
//

import Foundation

protocol SearchViewProtocol: class {
    func updateResults()
    func handleError(error: Error)
}

protocol SearchViewPresenterProtocol: class {
    var results: [Person]? { get set }
    var isRecents: Bool? { get set }
    
    func clearResults()
    func searchPerson(name: String)
    func tapOnPerson(person: Person?)
    
    init(view: SearchViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
}

class SearchPresenter: SearchViewPresenterProtocol {
    weak var view: SearchViewProtocol?
    
    let networkService: NetworkServiceProtocol!
    let router: RouterProtocol
    
    var results: [Person]?
    var isRecents: Bool?
    
    required init(view: SearchViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func clearResults() {
        results = nil
        isRecents = nil
        view?.updateResults()
    }
    
    func searchPerson(name: String) {
        clearResults()
        
        networkService.searchPerson(name: name) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self.results = results
                    self.isRecents = false
                    self.view?.updateResults()
                    
                case .failure(let error):
                    self.view?.handleError(error: error)
                }
            }
        }
    }
    
    func tapOnPerson(person: Person?) {
        router.showDetail(person: person)
    }
}
