//
//  TeamsCoordinator.swift
//  soccer
//
//  Created by Mikhail Andreev on 14.09.2021.
//

import UIKit

final class TeamsCoordinator: Coordinating {
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

  func start() {
    let viewModel = TeamsViewModel()
    let viewController = TeamsViewController(viewModel: viewModel)
    presenter.pushViewController(viewController, animated: true)
  }

}
