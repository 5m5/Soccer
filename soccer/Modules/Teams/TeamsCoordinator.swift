//
//  TeamsCoordinator.swift
//  soccer
//
//  Created by Mikhail Andreev on 14.09.2021.
//

import UIKit

final class TeamsCoordinator: NSObject, Coordinating {
  // MARK: - Protocol Properties
  var childCoordinators: [Coordinating] = []
  var presenter: UINavigationController

  // MARK: - Internal Properties
  lazy var viewModel: TeamsViewModel = {
    $0.coordinator = self
    return $0
  }(TeamsViewModel())

  lazy var viewController = TeamsViewController(viewModel: viewModel)

  // MARK: - Lifecycle
  init(presenter: UINavigationController) {
    self.presenter = presenter
  }

  convenience override init() {
    self.init(presenter: UINavigationController())
  }

  // MARK: - Protocol Methods
  func start() {
    presenter.delegate = self

    presenter.pushViewController(viewController, animated: true)
  }

  // MARK: - Internal Methods
  func tableViewCellTapped(teamResponse: TeamResponse) {
    let child = TeamDetailsCoordinator(presenter: presenter, teamResponse: teamResponse)
    childCoordinators.append(child)
    child.start()
  }

}

// MARK: - UINavigationControllerDelegate
extension TeamsCoordinator: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    guard
      let fromViewController = presenter.transitionCoordinator?.viewController(forKey: .from),
      !presenter.viewControllers.contains(fromViewController),
      let viewController = fromViewController as? StatisticViewController,
      let coordinator = viewController.viewModel.coordinator else { return }

    finish(child: coordinator)
  }

}
