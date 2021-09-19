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
  var matchResponse: MatchResponse

  // MARK: - Lifecycle
  init(presenter: UINavigationController, matchResponse: MatchResponse) {
    self.presenter = presenter
    self.matchResponse = matchResponse
  }

  // MARK: - Protocol Methods
  func start() {
    let viewModel = StatisticViewModel(matchResponse: matchResponse)
    viewModel.coordinator = self
    let viewController = StatisticViewController(viewModel: viewModel)
    presenter.pushViewController(viewController, animated: true)
  }

}
