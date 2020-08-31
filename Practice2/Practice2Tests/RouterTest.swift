//
//  RouterTest.swift
//  Practice2Tests
//
//  Created by Anton Pryakhin on 05.03.2020.
//

import XCTest
@testable import Practice2

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        presentedVC = viewController
    }
}

class RouterTest: XCTestCase {
    var router: RouterProtocol!
    let navigationController = MockNavigationController()
    let assemblyBuilder = AssemblyBuilder()
    
    override func setUp() {
        router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
    }

    override func tearDown() {
        router = nil
    }
    
    func testRouter() {
        router.showDetail(person: nil)
        let detailViewController = navigationController.presentedVC
        XCTAssertTrue(detailViewController is DetailViewController)
    }
}
