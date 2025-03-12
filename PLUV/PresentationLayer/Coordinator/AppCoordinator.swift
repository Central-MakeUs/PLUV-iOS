//
//  AppCoordinator.swift
//  PLUV
//
//  Created by jaegu park on 2/27/25.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    // MARK: - Property
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Start
    func start() {}
}
