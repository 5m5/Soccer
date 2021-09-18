//
//  StatisticViewController.swift
//  soccer
//
//  Created by Mikhail Andreev on 11.09.2021.
//

import UIKit

final class StatisticViewController: ViewModelController<StatisticViewModelProtocol> {

  // MARK: - Private Properties
  private lazy var matchDateLabel = makeLabel()
  private lazy var homeImageView = makeImageView()
  private lazy var homeLabel = makeLabel()
  private lazy var scoreLabel = makeLabel()
  private lazy var awayImageView = makeImageView()
  private lazy var awayLabel = makeLabel()

  private lazy var stackView = makeStackView()

  private lazy var tableView = makeTableView()

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.fetchStatistic { [weak self] in
      guard let self = self else { return }
      self.tableView.reloadData()
    }

    setupView()
  }

}

// MARK: - Private Methods
private extension StatisticViewController {
  private func setupView() {
    view.backgroundColor = .systemBackground
    addSubviews()
    setupConstraints()

    asyncLoadImages(viewModel: viewModel)
    scoreLabel.text = viewModel.scoreLabel
    let teamNames = viewModel.teamNames
    homeLabel.text = teamNames.home
    awayLabel.text = teamNames.away
    matchDateLabel.text = viewModel.matchDateString
  }

  private func addSubviews() {
    view.addSubview(matchDateLabel)
    view.addSubview(stackView)
    view.addSubview(tableView)
  }

  func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    NSLayoutConstraint.activate([
      matchDateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
      matchDateLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      matchDateLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),

      stackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 3 / 4),
      stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      stackView.topAnchor.constraint(equalTo: matchDateLabel.bottomAnchor, constant: 10),

      homeImageView.widthAnchor.constraint(equalToConstant: 60),
      homeImageView.heightAnchor.constraint(equalTo: homeImageView.widthAnchor),

      awayImageView.widthAnchor.constraint(equalTo: homeImageView.widthAnchor),
      awayImageView.heightAnchor.constraint(equalTo: awayImageView.widthAnchor),

      tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
      tableView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      tableView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
      tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

      scoreLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
    ])
  }

  private func makeStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    stackView.addArrangedSubview(makeTeamStackView(isHomeTeam: true))
    stackView.addArrangedSubview(scoreLabel)
    stackView.addArrangedSubview(makeTeamStackView(isHomeTeam: false))
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }

  private func makeTeamStackView(isHomeTeam: Bool) -> UIStackView {

    let teamImageView = isHomeTeam ? homeImageView : awayImageView
    let teamLabel = isHomeTeam ? homeLabel : awayLabel

    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.addArrangedSubview(teamImageView)
    stackView.addArrangedSubview(teamLabel)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }

  private func makeLabel() -> UILabel {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

  private func makeImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }

  private func makeTableView() -> UITableView {
    let tableView = UITableView()
    let identifier = StatisticCellViewModel.identifier
    tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: identifier)
    tableView.dataSource = self
    tableView.contentMode = .center
    tableView.allowsSelection = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }

  func asyncLoadImages(viewModel: StatisticViewModelProtocol) {
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

}

// MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.statisticsCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = StatisticCellViewModel.identifier
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: identifier,
      for: indexPath
    ) as? StatisticTableViewCell else { preconditionFailure("Can't cast cell") }

    cell.viewModel = viewModel.statisticCellViewModel(for: indexPath)
    return cell
  }

}
