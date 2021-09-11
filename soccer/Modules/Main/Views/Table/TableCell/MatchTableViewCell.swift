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

  // MARK: - Private Properties
  // Слева направо
  private lazy var homeImageView = imageView()
  private lazy var homeTeamLabel = teamNameLabel()
  private lazy var scoreLabel = setupScoreLabel()
  private lazy var awayTeamLabel = teamNameLabel()
  private lazy var awayImageView = imageView()

  private lazy var stackView: UIStackView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.alignment = .center
    $0.distribution = .equalCentering
    $0.axis = .horizontal
    $0.addArrangedSubview(homeImageView)
    $0.addArrangedSubview(homeTeamLabel)
    $0.addArrangedSubview(scoreLabel)
    $0.addArrangedSubview(awayTeamLabel)
    $0.addArrangedSubview(awayImageView)
    return $0
  }(UIStackView())

  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    contentView.backgroundColor = .secondarySystemBackground
    selectionStyle = .none
    setupSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    homeImageView.image = nil
    awayImageView.image = nil
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let constant: CGFloat = 10
    let insets = UIEdgeInsets(top: constant, left: 0, bottom: constant, right: 0)
    contentView.frame = contentView.frame.inset(by: insets)
    let contentLayer = contentView.layer
    contentLayer.cornerRadius = 12
    contentLayer.masksToBounds = true
  }

}

// MARK: - Private Methods
private extension MatchTableViewCell {

  func setupData() {
    guard let viewModel = viewModel else { preconditionFailure("Can't unwrap viewModel") }
    scoreLabel.text = viewModel.scoreLabelText

    let scoreLabelFont = viewModel.scoreLabelFont
    scoreLabel.font = UIFont(name: scoreLabelFont.name, size: CGFloat(scoreLabelFont.size))
    let teamNames = viewModel.teamNames
    homeTeamLabel.text = teamNames.home
    awayTeamLabel.text = teamNames.away
    asyncLoadImages(viewModel: viewModel)
  }

  func asyncLoadImages(viewModel: MatchCellViewModelProtocol) {
    DispatchQueue.global().async {
      let defaultImage = UIImage(named: viewModel.defaultImageName)
      var homeImage = defaultImage
      var awayImage = defaultImage

      let imagesData = viewModel.imagesData

      if let data = imagesData.home, let image = UIImage(data: data) {
        homeImage = image
      }

      if let data = imagesData.away, let image = UIImage(data: data) {
        awayImage = image
      }

      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.homeImageView.image = homeImage
        self.awayImageView.image = awayImage
      }
    }
  }

  func setupSubviews() {
    addSubview(stackView)
    setupConstraints()
  }

  func setupConstraints() {
    setupStackViewConstraints()
    setupImagesConstraints()
  }

  func setupStackViewConstraints() {
    let constant: CGFloat = 5

    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.leadingAnchor,
        constant: constant
      ),
      stackView.trailingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.trailingAnchor,
        constant: -constant
      ),
      stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  func setupImagesConstraints() {
    NSLayoutConstraint.activate([
      homeImageView.widthAnchor.constraint(equalToConstant: 50),
      homeImageView.heightAnchor.constraint(equalTo: homeImageView.widthAnchor),

      awayImageView.widthAnchor.constraint(equalTo: homeImageView.widthAnchor),
      awayImageView.heightAnchor.constraint(equalTo: awayImageView.widthAnchor),
    ])
  }

  func setupScoreLabel() -> UILabel {
    let label = UILabel()
    label.textColor = .label
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

  func imageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }

  func teamNameLabel() -> UILabel {
    let label = UILabel()
    label.textColor = .label
    label.numberOfLines = 2
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

}
