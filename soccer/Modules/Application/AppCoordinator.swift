//
//  AppCoordinator.swift
//  soccer
//
//  Created by Mikhail Andreev on 01.09.2021.
//

import UIKit

final class AppCoordinator: Coordinating {
  // MARK: - Internal Properties
  var childCoordinators: [Coordinating] = []
  var presenter: UINavigationController

  // MARK: - Lifecycle
  init(presenter: UINavigationController) {
    self.presenter = presenter
  }

  convenience init() {
    self.init(presenter: UINavigationController())
  }

  // MARK: - Internal Methods
  func start() {
    configurateNavigationBar()

    let child = MainCoordinator(presenter: presenter)
    childCoordinators.append(child)
    child.start()
  }

}

private extension AppCoordinator {
  func configurateNavigationBar() {

  }

}
