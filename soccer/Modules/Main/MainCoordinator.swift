//
//  MainCoordinator.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import UIKit

final class MainCoordinator: Coordinating {
  // MARK: - Protocol Properties
  var childCoordinators: [Coordinating] = []
  var presenter: UINavigationController

  // MARK: - Lifecycle
  init(presenter: UINavigationController) {
    self.presenter = presenter
  }

  // MARK: - Protocol Methods
  func start() {
    let viewModel = MainViewModel()
    viewModel.coordinator = self
    let viewController = MainViewController(viewModel: viewModel)
    presenter.pushViewController(viewController, animated: true)
  }

  // MARK: - Internal Methods
  func tableViewCellTapped(matchId: Int) {
    let child = StatisticCoordinator(presenter: presenter, matchId: matchId)
    childCoordinators.append(child)
    child.start()
  }

}
