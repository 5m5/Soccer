//
//  StatisticTableViewCell.swift
//  soccer
//
//  Created by Mikhail Andreev on 12.09.2021.
//

import UIKit

final class StatisticTableViewCell: UITableViewCell {

  // MARK: - Internal Properties
  var viewModel: StatisticCellViewModelProtocol? {
    didSet {
      precondition(viewModel != nil, "ViewModel should not be nil")
      guard let viewModel = viewModel else { return }

      homeValueLabel.text = viewModel.statisticHome
      parameterNameLabel.text = viewModel.statisticType
      awayValueLabel.text = viewModel.statisticAway
    }
  }

  // MARK: - Private Properties
  private lazy var stackView = makeStackView()
  private lazy var homeValueLabel = makeLabel()
  private lazy var parameterNameLabel = makeLabel()
  private lazy var awayValueLabel = makeLabel()

  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }

}

private extension StatisticTableViewCell {
  func setupView() {
    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  func makeStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .equalCentering
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(homeValueLabel)
    stackView.addArrangedSubview(parameterNameLabel)
    stackView.addArrangedSubview(awayValueLabel)
    return stackView
  }

  func makeLabel() -> UILabel {
    let label = UILabel()
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

}
