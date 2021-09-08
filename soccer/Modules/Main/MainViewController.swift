//
//  MainViewController.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import UIKit

final class MainViewController: ViewModelController<MainViewModelProtocol> {

  // MARK: - Private Properties
  private lazy var leagueCollectionView: LeagueCollectionView = {
    $0.delegate = self
    $0.dataSource = self
    return $0
  }(LeagueCollectionView())

  private lazy var matchTableView: MatchTableView = {
    $0.delegate = self
    $0.dataSource = self
    $0.rowHeight = 70
    return $0
  }(MatchTableView())

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.fetchLeagues { [weak self] in
      guard let self = self else { return }
      self.leagueCollectionView.reloadData()
      self.leagueCollectionView.selectItem(
        at: IndexPath(item: 0, section: 0),
        animated: true,
        scrollPosition: .left
      )

      self.viewModel.fetchMatches {
        self.matchTableView.reloadData()
      }

    }

    view.backgroundColor = .systemBackground

    view.addSubview(leagueCollectionView)
    view.addSubview(matchTableView)

    let safeArea = view.safeAreaLayoutGuide
    let constant: CGFloat = 16
    NSLayoutConstraint.activate([
      leagueCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      leagueCollectionView.leadingAnchor.constraint(
        equalTo: safeArea.leadingAnchor,
        constant: constant),

      leagueCollectionView.trailingAnchor.constraint(
        equalTo: safeArea.trailingAnchor,
        constant: -constant),

      leagueCollectionView.heightAnchor.constraint(
        equalTo: safeArea.heightAnchor,
        multiplier: 1 / 4
      ),

      matchTableView.topAnchor.constraint(
        equalTo: leagueCollectionView.bottomAnchor,
        constant: constant
      ),
      matchTableView.leadingAnchor.constraint(equalTo: leagueCollectionView.leadingAnchor),
      matchTableView.trailingAnchor.constraint(equalTo: leagueCollectionView.trailingAnchor),
      matchTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -constant),

    ])
  }

}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {

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
    ) as? LeagueCollectionViewCell else { return UICollectionViewCell() }

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

}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.matchesCount
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = MatchCellViewModel.identifier
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: identifier
    ) as? MatchTableViewCell else { return UITableViewCell() }

    cell.viewModel = viewModel.matchCellViewModel(for: indexPath)
    return cell
  }

}
