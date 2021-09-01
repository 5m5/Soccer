//
//  MainCoordinator.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import UIKit

final class MainCoordinator: Coordinating {
  // MARK: - Internal Properties
  var childCoordinators: [Coordinating] = []
  var presenter: UINavigationController

  // MARK: - Lifecycle
  init(presenter: UINavigationController) {
    self.presenter = presenter
  }

  // MARK: - Internal Methods
  func start() {
    let viewModel = MainViewModel()
    let viewController = MainViewController(viewModel: viewModel)
    presenter.pushViewController(viewController, animated: true)
  }

}
