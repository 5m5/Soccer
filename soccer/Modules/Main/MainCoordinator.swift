//
//  MainCoordinator.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import UIKit

final class MainCoordinator: NSObject, Coordinating {
  // MARK: - Protocol Properties
  var childCoordinators: [Coordinating] = []
  var presenter: UINavigationController

  // MARK: - Lifecycle
  init(presenter: UINavigationController) {
    self.presenter = presenter
  }

  // MARK: - Protocol Methods
  func start() {
    presenter.delegate = self

    let viewModel = MainViewModel()
    viewModel.coordinator = self
    let viewController = MainViewController(viewModel: viewModel)
    presenter.pushViewController(viewController, animated: true)
  }

  // MARK: - Internal Methods
  func tableViewCellTapped(matchResponse: MatchResponse) {
    let child = StatisticCoordinator(presenter: presenter, matchResponse: matchResponse)
    childCoordinators.append(child)
    child.start()
  }

}

// MARK: - UINavigationControllerDelegate
extension MainCoordinator: UINavigationControllerDelegate {
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
