//
//  TeamDetailsCoordinator.swift
//  soccer
//
//  Created by Mikhail Andreev on 18.09.2021.
//

import UIKit

final class TeamDetailsCoordinator: Coordinating {
  // MARK: - Protocol Properties
  var childCoordinators: [Coordinating] = []
  var presenter: UINavigationController

  // MARK: - Internal Properties
  var teamResponse: TeamResponse

  // MARK: - Lifecycle
  init(presenter: UINavigationController, teamResponse: TeamResponse) {
    self.presenter = presenter
    self.teamResponse = teamResponse
  }

  func start() {
    let viewModel = TeamDetailsViewModel(teamResponse: teamResponse)
    viewModel.coordinator = self
    let viewController = TeamDetailsViewController(viewModel: viewModel)
    presenter.pushViewController(viewController, animated: true)
  }
}
