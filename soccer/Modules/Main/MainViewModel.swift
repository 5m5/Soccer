//
//  MainViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

// MARK: - Protocol
protocol MainViewModelProtocol: AnyObject {
  var title: String { get }
  var constraintMargin: Int { get }
  var collectionViewHeightMultiplier: Float { get }
  var leagues: [LeagueResponse] { get }
  var leaguesCount: Int { get }
  var matches: [MatchResponse] { get }
  var matchesCount: Int { get }
  func fetchLeagues(completion: @escaping () -> Void)
  func collectionView(didSelectItemAt indexPath: IndexPath, completion: @escaping () -> Void)
  func leagueCellViewModel(for indexPath: IndexPath) -> LeagueCellViewModelProtocol
  func matchCellViewModel(for indexPath: IndexPath) -> MatchCellViewModelProtocol
}

// MARK: - Implementation
final class MainViewModel: MainViewModelProtocol {

  var title = "Matches history"
  var constraintMargin = 16
  var collectionViewHeightMultiplier: Float = 0.25

  var leagues: [LeagueResponse] = []
  var leaguesCount = 0

  var matches: [MatchResponse] = []
  var matchesCount = 0

  func collectionView(didSelectItemAt indexPath: IndexPath, completion: @escaping () -> Void) {
    let index = indexPath.row
    let leagueResponse = leagues[index]
    let leagueId = leagueResponse.league.id
    guard let season = leagueResponse.seasons.max(by: { $0.year < $1.year }) else { return }
    let seasonYear = season.year

    let parser = JSONParser<MatchResult>()

    let urlBuilder = URLBuilder()
    let urlRequest = urlBuilder
      .with(endPoint: .matches)
      .with(seasonYear: seasonYear)
      .with(leagueID: leagueId)
      .urlRequest

    fetch(parser: parser, urlRequest: urlRequest) { [weak self] matches in
      guard let self = self else { return }

      self.matches = matches.response
      self.matchesCount = matches.count
      completion()
    }
  }

  func fetchLeagues(completion: @escaping () -> Void) {
    let parser = JSONParser<LeagueResult>()

    let urlBuilder = URLBuilder()
    let urlRequest = urlBuilder.with(endPoint: .leagues).urlRequest

    fetch(parser: parser, urlRequest: urlRequest) { [weak self] leagues in
      guard let self = self else { return }

      self.leagues = leagues.response
      self.leaguesCount = leagues.count
      completion()
    }
  }

  func leagueCellViewModel(for indexPath: IndexPath) -> LeagueCellViewModelProtocol {
    let leagueResponse = leagues[indexPath.row]
    return LeagueCellViewModel(league: leagueResponse.league)
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
