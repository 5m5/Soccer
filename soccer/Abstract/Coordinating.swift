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
  func finish()
}

extension Coordinating {
  func finish() {}
}
