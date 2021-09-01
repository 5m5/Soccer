//
//  MVVMViewController.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import UIKit

protocol MVVMViewControllerProtocol: UIViewController {
  associatedtype ViewModel
  var viewModel: ViewModel { get }
  init(viewModel: ViewModel)
}

class MVVMViewController<ViewModel>: UIViewController, MVVMViewControllerProtocol {

  // MARK: - Internal Properties
  var viewModel: ViewModel

  // MARK: - Lifecycle
  required init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }

}
