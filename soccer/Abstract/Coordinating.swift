//
//  Coordinating.swift
//  soccer
//
//  Created by Mikhail Andreev on 01.09.2021.
//

import UIKit

protocol Coordinating: AnyObject {
  var childCoordinators: [Coordinating] { get set }
  var presenter: UINavigationController { get set }

  func start()
  func finish(child: Coordinating)
}

extension Coordinating {
  func finish(child: Coordinating) {
    for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
      childCoordinators.remove(at: index)
      break
    }
  }
}
