//
//  MainViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

// MARK: - Protocol
protocol MainViewModelProtocol: AnyObject {
  var leagues: [LeagueResponse] { get }
  var leaguesCount: Int { get }
  var matches: [MatchResponse] { get }
  var matchesCount: Int { get }
  func fetchLeagues(completion: @escaping () -> Void)
  func fetchMatches(completion: @escaping () -> Void)
  func leagueCellViewModel(for indexPath: IndexPath) -> LeagueCellViewModelProtocol
  func matchCellViewModel(for indexPath: IndexPath) -> MatchCellViewModelProtocol
}

// MARK: - Implementation
final class MainViewModel: MainViewModelProtocol {

  var leagues: [LeagueResponse] = []
  var leaguesCount: Int = 0

  var matches: [MatchResponse] = []
  var matchesCount: Int = 0

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

  func fetchMatches(completion: @escaping () -> Void) {
    let parser = JSONParser<MatchResult>()

    let urlBuilder = URLBuilder()
    let urlRequest = urlBuilder
      .with(endPoint: .matches)
      .with(seasonYear: 2021)
      .with(leagueID: 140)
      .urlRequest

    fetch(parser: parser, urlRequest: urlRequest) { [weak self] matches in
      guard let self = self else { return }

      self.matches = matches.response
      self.matchesCount = matches.count
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
extension MainViewModel {
  private func fetch<T: Codable>(
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
