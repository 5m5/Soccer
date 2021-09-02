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

    viewModel.fetchLeagues { print() }

    view.backgroundColor = .systemBackground
    print(viewModel.leagues)
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      print(self.viewModel.leagues)
    }
  }

}
