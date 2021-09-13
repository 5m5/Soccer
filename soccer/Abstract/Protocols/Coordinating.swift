//
//  Coordinating.swift
//  soccer
//
//  Created by Mikhail Andreev on 01.09.2021.
//

import UIKit

// MARK: - Protocol
protocol Coordinating: AnyObject {
  var childCoordinators: [Coordinating] { get set }
  var presenter: UINavigationController { get set }

  func start()
  func finish(child: Coordinating)
}

// MARK: - Extension
extension Coordinating {
  func finish(child: Coordinating) {
    for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
      childCoordinators.remove(at: index)
      break
    }
  }
}
