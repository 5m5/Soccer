//
//  MatchTableViewCell.swift
//  soccer
//
//  Created by Mikhail Andreev on 04.09.2021.
//

import UIKit

final class MatchTableViewCell: UITableViewCell {

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
    $0.spacing = 5
    $0.addArrangedSubview(homeImageView)
    $0.addArrangedSubview(homeTeamLabel)
    $0.addArrangedSubview(scoreLabel)
    $0.addArrangedSubview(awayTeamLabel)
    $0.addArrangedSubview(awayImageView)
    return $0
  }(UIStackView())

  private var workItem: DispatchWorkItem?
  private var uiWorkItem: DispatchWorkItem?

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
    viewModel?.prepareForReuse()
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

    scoreLabel.font = UIFont(name: "Avenir-Light", size: 22)
    let teamNames = viewModel.teamNames
    homeTeamLabel.text = teamNames.home
    awayTeamLabel.text = teamNames.away
    asyncLoadImages(viewModel: viewModel)
  }

  func asyncLoadImages(viewModel: MatchCellViewModelProtocol) {
    let defaultImage = UIImage(named: "football_club")

    viewModel.fetchImages { [weak self] in
      guard let self = self else { return }

      self.homeImageView.image = defaultImage
      self.awayImageView.image = defaultImage

      if let data = viewModel.homeImageData, let image = UIImage(data: data) {
        self.homeImageView.image = image
      }

      if let data = viewModel.awayImageData, let image = UIImage(data: data) {
        self.awayImageView.image = image
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

      scoreLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
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
    label.numberOfLines = 1
    label.lineBreakMode = .byTruncatingTail
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

}
