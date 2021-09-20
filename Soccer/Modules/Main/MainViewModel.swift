//
//  MainViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

// MARK: - Protocol
protocol MainViewModelProtocol: AnyObject {
  var coordinator: MainCoordinator? { get }
  var title: String { get }

  var leaguesLabelTitle: String { get }
  var leagues: [LeagueResponse] { get }
  var leaguesCount: Int { get }
  var leagueName: String { get }

  var leaguesParser: JSONParser<LeagueResult> { get }
  var matchesParser: JSONParser<MatchResult> { get }

  var matches: [MatchResponse] { get } // TODO: убрать?
  var matchesCount: Int { get }
  func fetchLeagues(completion: @escaping () -> Void)
  func collectionView(didSelectItemAt indexPath: IndexPath, completion: @escaping () -> Void)
  func tableView(didSelectRowAt indexPath: IndexPath)
  func leagueCellViewModel(for indexPath: IndexPath) -> ImageCellViewModelProtocol
  func matchCellViewModel(for indexPath: IndexPath) -> MatchCellViewModelProtocol
}

// MARK: - Implementation
final class MainViewModel: MainViewModelProtocol {
  weak var coordinator: MainCoordinator?

  var title = "Matches history"
  var leaguesLabelTitle = "Select league"

  var leagues: [LeagueResponse] = []
  var leaguesCount = 0
  var leagueName = ""

  var leaguesParser = JSONParser<LeagueResult>()
  var matchesParser = JSONParser<MatchResult>()

  var matches: [MatchResponse] = []
  var matchesCount = 0

  private var endPoint = EndPointFactory()

  private var collectionIndexPath = IndexPath()

  func fetchLeagues(completion: @escaping () -> Void) {

    let urlBuilder = endPoint.leagues()
    let urlRequest = urlBuilder.urlRequest

    fetch(parser: leaguesParser, urlRequest: urlRequest) { [weak self] leagues in
      guard let self = self else { return }

      self.leagues = leagues.response
      self.leaguesCount = leagues.count
      completion()
    }
  }

  func collectionView(didSelectItemAt indexPath: IndexPath, completion: @escaping () -> Void) {
    if indexPath == collectionIndexPath { return }

    collectionIndexPath = indexPath

    let index = indexPath.row
    let leagueResponse = leagues[index]
    let league = leagueResponse.league
    let leagueId = league.id

    leagueName = league.name
    // Пока отображаем только последние сезоны лиг
    guard let season = leagueResponse.seasons.max(by: { $0.year < $1.year }) else { return }
    let seasonYear = season.year

    let urlBuilder = endPoint.matches()
    let urlRequest = urlBuilder
      .with(seasonYear: seasonYear)
      .with(leagueID: leagueId)
      .urlRequest

    fetch(parser: matchesParser, urlRequest: urlRequest) { [weak self] matches in
      guard let self = self else { return }

      self.matches = matches.response.sorted { $0.match.timestamp > $1.match.timestamp }
      self.matchesCount = matches.count
      completion()
    }
  }

  func tableView(didSelectRowAt indexPath: IndexPath) {
    let index = indexPath.row
    let matchResponse = matches[index]

    precondition(coordinator != nil, "Coordinator should not be nil")
    coordinator?.tableViewCellTapped(matchResponse: matchResponse)
  }

  func leagueCellViewModel(for indexPath: IndexPath) -> ImageCellViewModelProtocol {
    let leagueResponse = leagues[indexPath.row]
    return ImageCellViewModel(imagePath: leagueResponse.league.logo)
  }

  func matchCellViewModel(for indexPath: IndexPath) -> MatchCellViewModelProtocol {
    let matchResponse = matches[indexPath.row]
    return MatchCellViewModel(matchResponse: matchResponse)
  }

}

// MARK: - Private methods
private extension MainViewModel {
  func fetch<T: Codable>(
    parser: JSONParser<T>,
    urlRequest: URLRequest,
    completion: @escaping (T) -> Void
  ) {
    parser.fetch(urlRequest: urlRequest) { result in
      switch result {
      case .success(let result):
        DispatchQueue.main.async {
          completion(result)
        }
      case .failure(let error):
        if error is NetworkError {
          print(error)
        } else {
          print(error.localizedDescription)
        }
      }
    }
  }

}
