//
//  TabBarController.swift
//  soccer
//
//  Created by Mikhail Andreev on 13.09.2021.
//

import UIKit

final class TabBarController: UITabBarController {

  // MARK: - Private Properties
  private lazy var mainCoordinator = MainCoordinator()
  private lazy var mainViewController: UIViewController = {
    let title = mainCoordinator.viewModel.title
    let viewController = viewController(from: mainCoordinator, title: title, imageName: "field")
    return viewController
  }()

  private lazy var teamsCoordinator = TeamsCoordinator()
  private lazy var teamsViewController: UIViewController = {
    let title = teamsCoordinator.viewModel.title
    let viewController = viewController(from: teamsCoordinator, title: title, imageName: "team")
    return viewController
  }()

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setViewControllers([mainViewController, teamsViewController], animated: false)
    mainCoordinator.start()
    teamsCoordinator.start()
  }

}

// MARK: - Private Methods
private extension TabBarController {
  func viewController(
    from coordinator: Coordinating,
    title: String?,
    imageName: String
  ) -> UIViewController {
    let viewController = coordinator.presenter
    let image = UIImage(named: imageName)
    let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
    viewController.tabBarItem = tabBarItem
    return viewController
  }

}
