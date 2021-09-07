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

  private lazy var homeImageView = imageView()
  private lazy var awayImageView = imageView()

  private lazy var scoreLabel: UILabel = {
    $0.font = UIFont(name: "Didot Bold", size: 22)
    $0.textColor = .label
    $0.textAlignment = .center
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UILabel())

  private lazy var stackView: UIStackView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.alignment = .center
    $0.distribution = .equalCentering
    $0.axis = .horizontal
    $0.addArrangedSubview(homeImageView)
    $0.addArrangedSubview(scoreLabel)
    $0.addArrangedSubview(awayImageView)
    return $0
  }(UIStackView())

  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }

}

// MARK: - Private Methods
private extension MatchTableViewCell {

  func setupData() {
    guard let viewModel = viewModel else { preconditionFailure("Can't unwrap viewModel") }
    scoreLabel.text = viewModel.scoreLabelText
  }

  private func setupSubviews() {
    addSubview(stackView)
    setupConstraints()
  }

  private func setupConstraints() {
    setupStackViewConstraints()
    setupImagesConstraints()
  }

  private func setupStackViewConstraints() {
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  private func setupImagesConstraints() {
    NSLayoutConstraint.activate([
      homeImageView.widthAnchor.constraint(equalToConstant: 60),
      homeImageView.heightAnchor.constraint(equalTo: homeImageView.widthAnchor),

      awayImageView.widthAnchor.constraint(equalTo: homeImageView.widthAnchor),
      awayImageView.heightAnchor.constraint(equalTo: awayImageView.widthAnchor),
    ])
  }

  private func imageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }

}
