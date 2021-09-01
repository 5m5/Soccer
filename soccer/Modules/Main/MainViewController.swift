//
//  MainViewController.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import UIKit

final class MainViewController: MVVMViewController<MainViewModelProtocol> {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .green
  }

}
