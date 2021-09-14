//
//  TeamTableViewCell.swift
//  soccer
//
//  Created by Mikhail Andreev on 14.09.2021.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

  // MARK: - Internal Properties
  var viewModel: TeamCellViewModelProtocol? {
    didSet {
      precondition(viewModel != nil, "ViewModel should not be nil")
      guard let viewModel = viewModel else { return }

      teamLabel.text = viewModel.teamName
      countryLabel.text = viewModel.countryName
      asyncLoadImage()
    }
  }

  // MARK: - Private Properties
  private lazy var teamLabel = makeLabel()
  private lazy var countryLabel = makeLabel()
  private lazy var teamLogoImageView = makeImageView()
  private lazy var stackView = makeStackView()

  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    teamLogoImageView.image = nil
  }

}

private extension TeamTableViewCell {

  func setupView() {
    addSubview(teamLogoImageView)
    addSubview(stackView)
    setupConstraints()
  }

  func setupConstraints() {
    let constant: CGFloat = 10
    setupImageViewConstraints(constant: constant)
    setupStackViewConstraints(constant: constant)
  }

  func setupImageViewConstraints(constant: CGFloat) {
    NSLayoutConstraint.activate([
      teamLogoImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),

      teamLogoImageView.leadingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.leadingAnchor,
        constant: constant
      ),

      teamLogoImageView.widthAnchor.constraint(equalToConstant: 80),
      teamLogoImageView.heightAnchor.constraint(equalTo: teamLogoImageView.widthAnchor),
    ])
  }

  func setupStackViewConstraints(constant: CGFloat) {
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(
        equalTo: teamLogoImageView.trailingAnchor,
        constant: constant
      ),

      stackView.heightAnchor.constraint(equalTo: teamLogoImageView.heightAnchor, multiplier: 3 / 4),
      stackView.trailingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.trailingAnchor,
        constant: -constant
      ),
      stackView.centerYAnchor.constraint(equalTo: teamLogoImageView.centerYAnchor),
    ])
  }

  func makeImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }

  func makeLabel() -> UILabel {
    let label = UILabel()
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

  func makeStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.alignment = .leading
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 5
    stackView.addArrangedSubview(teamLabel)
    stackView.addArrangedSubview(countryLabel)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }

  func asyncLoadImage() {
    guard let viewModel = viewModel else { preconditionFailure("Can't unwrap viewModel") }

    DispatchQueue.global().async {
      var image = UIImage(named: "football_player")

      if let data = viewModel.imageData, let teamLogoImage = UIImage(data: data) {
        image = teamLogoImage
      }

      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.teamLogoImageView.image = image
      }
    }
  }

}
