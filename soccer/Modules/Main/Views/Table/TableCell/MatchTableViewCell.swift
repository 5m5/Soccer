//
//  MatchTableViewCell.swift
//  soccer
//
//  Created by Mikhail Andreev on 04.09.2021.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

  // MARK: - Internal Properties
  var viewModel: MatchCellViewModelProtocol? {
    didSet { setupData() }
  }

  private lazy var homeScoreLabel: UILabel = {
    $0.font = UIFont(name: "Didot Bold", size: 18)
    $0.textColor = .label
    $0.textAlignment = .center
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UILabel())

  private lazy var stackView: UIStackView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.alignment = .firstBaseline
    $0.distribution = .fillEqually
    $0.axis = .horizontal
    $0.addArrangedSubview(homeScoreLabel)
    return $0
  }(UIStackView())

  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }

  // MARK: - Private Methods
  private func setupData() {
    guard let viewModel = viewModel else { preconditionFailure("Can't unwrap viewModel") }

    let goals = viewModel.matchResponse.goals
    let homeScore = goals.home ?? 0
    let awayScore = goals.away ?? 0
    homeScoreLabel.text = "\(homeScore) : \(awayScore)"
  }

}
