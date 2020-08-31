//
//  DetailPresenter.swift
//  Practice2
//
//  Created by Anton Pryakhin on 03.03.2020.
//

import Foundation

protocol DetailViewProtocol: class {

}

protocol DetailViewPresenterProtocol: class {
    var person: Person? { get set }
    
    init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, person: Person?)
}

class DetailPresenter: DetailViewPresenterProtocol {
    private weak var view: DetailViewProtocol?
    private let networkService: NetworkServiceProtocol!
    private let router: RouterProtocol!
    var person: Person?
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol,
                  router: RouterProtocol, person: Person?) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.person = person
    }
}
