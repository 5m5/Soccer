//
//  TeamsViewController.swift
//  soccer
//
//  Created by Mikhail Andreev on 14.09.2021.
//

import UIKit

final class TeamsViewController: ViewModelController<TeamsViewModelProtocol> {

  // MARK: - Private Properties
  private lazy var tableView = makeTableView()
  private lazy var searchController = UISearchController(searchResultsController: nil)

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
  }

}

// MARK: - Private Methods
private extension TeamsViewController {
  func makeTableView() -> UITableView {
    let tableView = UITableView()
    tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: TeamCellViewModel.identifier)
    tableView.rowHeight = 90
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }

  func setupView() {
    title = "Teams"
    view.backgroundColor = .systemBackground

    view.addSubview(tableView)
    setupSearchController()
    setupConstraints()
  }

  func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search teams"
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }

  func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
    ])
  }

}

// MARK: - UISearchResultsUpdating
extension TeamsViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text, text.count >= 3 else { return }

    viewModel.searchTeams(name: text) { [weak self] in
      guard let self = self else { return }

      self.tableView.reloadData()
    }
  }

}

// MARK: - UITableViewDataSource
extension TeamsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.teamsCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = TeamCellViewModel.identifier
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: identifier,
      for: indexPath
    ) as? TeamTableViewCell else { preconditionFailure("Can't cast cell") }

    cell.viewModel = viewModel.teamCellViewModel(for: indexPath)
    return cell
  }

}