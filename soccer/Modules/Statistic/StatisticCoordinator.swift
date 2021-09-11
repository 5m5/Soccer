//
//  StatisticCoordinator.swift
//  soccer
//
//  Created by Mikhail Andreev on 11.09.2021.
//

import UIKit

final class StatisticCoordinator: Coordinating {
  // MARK: - Protocol Properties
  var childCoordinators: [Coordinating] = []
  var presenter: UINavigationController

  // MARK: - Internal Properties
  var matchId: Int

  // MARK: - Lifecycle
  init(presenter: UINavigationController, matchId: Int) {
    self.presenter = presenter
    self.matchId = matchId
  }

  // MARK: - Protocol Methods
  func start() {
    let viewModel = StatisticViewModel(matchId: matchId)
    let viewController = StatisticViewController(viewModel: viewModel)
    presenter.pushViewController(viewController, animated: true)
  }

}
