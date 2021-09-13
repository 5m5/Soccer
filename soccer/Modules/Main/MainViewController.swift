//
//  MainViewController.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import UIKit

final class MainViewController: ViewModelController<MainViewModelProtocol> {

  // MARK: - Private Properties
  private lazy var leagueCollectionView = makeCollectionView()
  private lazy var matchTableView = makeTableView()
  private lazy var selectLeagueLabel = makeLabel()
  private lazy var leagueNameLabel = makeLabel()

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.fetchLeagues { [weak self] in
      guard let self = self else { return }
      self.leagueCollectionView.reloadData()
      let indexPath = IndexPath(item: 0, section: 0)
      self.leagueCollectionView.selectItem(
        at: indexPath,
        animated: true,
        scrollPosition: .left
      )

      self
        .leagueCollectionView
        .delegate?
        .collectionView?(self.leagueCollectionView, didSelectItemAt: indexPath)
    }

    setupView()
  }

}

// MARK: - Private Methods
private extension MainViewController {
  func makeCollectionView() -> LeagueCollectionView {
    let collectionView = LeagueCollectionView()
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }

  func makeTableView() -> MatchTableView {
    let tableView = MatchTableView()
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }

  func makeLabel() -> UILabel {
    let label = UILabel()
    let font = viewModel.labelsFont
    label.font = UIFont(name: font.name, size: CGFloat(font.size))
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

  func setupView() {
    title = viewModel.title
    selectLeagueLabel.text = viewModel.leaguesLabelTitle
    view.backgroundColor = .systemBackground
    addSubviews()

    let safeArea = view.safeAreaLayoutGuide
    let margin = CGFloat(viewModel.constraintMargin)
    setupConstraints(safeArea: safeArea, margin: margin)
  }

  func addSubviews() {
    view.addSubview(leagueCollectionView)
    view.addSubview(matchTableView)
    view.addSubview(selectLeagueLabel)
    view.addSubview(leagueNameLabel)
  }

  func setupConstraints(safeArea: UILayoutGuide, margin: CGFloat) {
    setupLabelsConstraints(safeArea: safeArea, margin: margin)
    setupCollectionViewConstraints(safeArea: safeArea, margin: margin)
    setupTableViewConstraints(safeArea: safeArea, margin: margin)
  }

  func setupLabelsConstraints(safeArea: UILayoutGuide, margin: CGFloat) {
    NSLayoutConstraint.activate([
      selectLeagueLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
      selectLeagueLabel.leadingAnchor.constraint(equalTo: leagueCollectionView.leadingAnchor),
      selectLeagueLabel.trailingAnchor.constraint(equalTo: leagueCollectionView.trailingAnchor),

      leagueNameLabel.topAnchor.constraint(
        equalTo: leagueCollectionView.bottomAnchor,
        constant: margin
      ),
      leagueNameLabel.leadingAnchor.constraint(equalTo: selectLeagueLabel.leadingAnchor),
      leagueNameLabel.trailingAnchor.constraint(equalTo: selectLeagueLabel.trailingAnchor),
    ])
  }

  func setupCollectionViewConstraints(safeArea: UILayoutGuide, margin: CGFloat) {
    NSLayoutConstraint.activate([
      leagueCollectionView.topAnchor.constraint(
        equalTo: selectLeagueLabel.bottomAnchor,
        constant: margin
      ),

      leagueCollectionView.leadingAnchor.constraint(
        equalTo: safeArea.leadingAnchor,
        constant: margin
      ),

      leagueCollectionView.trailingAnchor.constraint(
        equalTo: safeArea.trailingAnchor,
        constant: -margin),

      leagueCollectionView.heightAnchor.constraint(
        equalTo: safeArea.heightAnchor,
        multiplier: CGFloat(viewModel.collectionViewHeightMultiplier)
      ),
    ])
  }

  func setupTableViewConstraints(safeArea: UILayoutGuide, margin: CGFloat) {
    NSLayoutConstraint.activate([
      matchTableView.topAnchor.constraint(
        equalTo: leagueNameLabel.bottomAnchor,
        constant: margin
      ),

      matchTableView.leadingAnchor.constraint(equalTo: leagueCollectionView.leadingAnchor),
      matchTableView.trailingAnchor.constraint(equalTo: leagueCollectionView.trailingAnchor),
      matchTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -margin),
    ])
  }

}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.collectionView(didSelectItemAt: indexPath) { [weak self] in
      guard let self = self else { return }
      self.matchTableView.reloadData()
    }
    // По идее это вне блока, который в сеть ходит, так что можно вне замыкания
    self.leagueNameLabel.text = self.viewModel.leagueName

    leagueCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
  }

}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    viewModel.leaguesCount
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let identifier = LeagueCellViewModel.identifier
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: identifier,
      for: indexPath
    ) as? LeagueCollectionViewCell else { preconditionFailure("Can't cast cell") }

    cell.viewModel = viewModel.leagueCellViewModel(for: indexPath)
    return cell
  }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let insets = collectionView.contentInset
    let height = collectionView.bounds.height - insets.top - insets.bottom - 1
    return CGSize(width: collectionView.bounds.width / 4, height: height)
  }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.tableView(didSelectRowAt: indexPath)
  }

}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.matchesCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = MatchCellViewModel.identifier
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: identifier
    ) as? MatchTableViewCell else { preconditionFailure("Can't cast cell") }

    cell.viewModel = viewModel.matchCellViewModel(for: indexPath)
    return cell
  }

}
