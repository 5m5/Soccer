//
//  AppCoordinator.swift
//  soccer
//
//  Created by Mikhail Andreev on 01.09.2021.
//

import UIKit

final class AppCoordinator: Coordinating {
  // MARK: - Protocol Properties
  var childCoordinators: [Coordinating] = []
  var presenter: UINavigationController

  // MARK: - Lifecycle
  init(presenter: UINavigationController) {
    self.presenter = presenter
  }

  convenience init() {
    self.init(presenter: UINavigationController())
  }

  // MARK: - Protocol Methods
  func start() {
    let child = MainCoordinator(presenter: presenter)
    childCoordinators.append(child)
    child.start()
  }

}
