//
//  AssemblyBuilder.swift
//  Practice2
//
//  Created by Anton Pryakhin on 03.03.2020.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createSearchModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(person: Person?, router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createSearchModule(router: RouterProtocol) -> UIViewController {
        let view = SearchViewController()
        let networkService = NetworkService()
        let presenter = SearchPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }

    func createDetailModule(person: Person?, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let networkService = NetworkService()
        let presenter = DetailPresenter(view: view, networkService: networkService,
                                        router: router, person: person)
        view.presenter = presenter
        return view
    }
}
