//
//  MainViewController.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import UIKit

final class MainViewController: MVVMViewController<MainViewModelProtocol> {

  // MARK: - Private Properties
  private lazy var leagueCollectionView: LeagueCollectionView = {
    $0.delegate = self
    $0.dataSource = self
    return $0
  }(LeagueCollectionView())

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.fetchLeagues { [weak self] in
      guard let self = self else { return }
      self.leagueCollectionView.reloadData()
    }

    view.backgroundColor = .systemBackground

    view.addSubview(leagueCollectionView)

    let safeArea = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      leagueCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      leagueCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
      leagueCollectionView.trailingAnchor.constraint(
        equalTo: safeArea.trailingAnchor,
        constant: -8),

      leagueCollectionView.heightAnchor.constraint(
        equalTo: safeArea.heightAnchor,
        multiplier: 1 / 4
      ),

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

    cell.viewModel = LeagueCellViewModel(league: viewModel.leagues.first!)
    return cell
  }

}
