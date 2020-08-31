//
//  Router.swift
//  Practice2
//
//  Created by Anton Pryakhin on 03.03.2020.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(person: Person?)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let searchViewController =
                assemblyBuilder?.createSearchModule(router: self) else { return }
            navigationController.viewControllers = [searchViewController]
        }
    }
    
    func showDetail(person: Person?) {
        if let navigationController = navigationController {
            guard let detailViewController =
                assemblyBuilder?.createDetailModule(person: person, router: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    init(navigationController: UINavigationController,
         assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
}
