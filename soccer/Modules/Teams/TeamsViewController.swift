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
  private lazy var startSearchLabel = makeLabel()

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    searchController.searchBar.delegate = self
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
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }

  func setupView() {
    title = viewModel.title
    view.backgroundColor = .systemBackground

    navigationItem.backBarButtonItem = UIBarButtonItem(
      title: "",
      style: .plain,
      target: nil,
      action: nil
    )

    teamsFromDataBase()

    view.addSubview(tableView)
    view.addSubview(startSearchLabel)
    setupSearchController()
    setupConstraints()
  }

  private func makeLabel() -> UILabel {
    let label = UILabel()
    label.text = "Start searching your favorite teams"
    label.isHidden = true
    label.font = UIFont(name: "Staubach", size: 24)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
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

      startSearchLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
      startSearchLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
      startSearchLabel.widthAnchor.constraint(equalTo: tableView.widthAnchor),
    ])
  }

  func teamsFromDataBase() {
    viewModel.fetchTeamsFromDataBase { [weak self] in
      guard let self = self else { return }
      self.tableView.reloadData()
      self.tableView.isHidden = self.viewModel.isTableViewHidden
      self.startSearchLabel.isHidden = !self.viewModel.isTableViewHidden
    }
  }

}

// MARK: - UISearchResultsUpdating
extension TeamsViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    tableView.isHidden = false
    startSearchLabel.isHidden = true
    guard let text = searchController.searchBar.text, text.count >= 3 else { return }

    viewModel.searchTeams(name: text) { [weak self] in
      guard let self = self else { return }

      self.tableView.reloadData()
    }
  }

}

// MARK: - UISearchBarDelegate
extension TeamsViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    teamsFromDataBase()
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

// MARK: - UITableViewDelegate
extension TeamsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.tableView(didSelectRowAt: indexPath)
  }

  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    if editingStyle == .delete {
      viewModel.removeRow(indexPath: indexPath)
      tableView.deleteRows(at: [indexPath], with: .automatic)

      tableView.isHidden = viewModel.isTableViewHidden
      startSearchLabel.isHidden = !viewModel.isTableViewHidden
    }
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    viewModel.isTableViewCanEditRow
  }

}
