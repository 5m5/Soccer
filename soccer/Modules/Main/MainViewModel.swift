//
//  MainViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
  var leagues: [LeagueResponse] { get }
  var leaguesCount: Int { get }
  func fetchLeagues(completion: @escaping () -> Void)
  func leagueCellViewModel(for indexPath: IndexPath) -> LeagueCellViewModelProtocol
}

final class MainViewModel: MainViewModelProtocol {

  init() {
    let urlBuilder = URLBuilder()
    let urlRequest = urlBuilder.with(endPoint: .matches).with(seasonYear: 2021).with(leagueID: 140)
      .urlRequest

    let parser = JSONParser<MatchResult>()
    parser.fetch(urlRequest: urlRequest) { result in
      switch result {
      case .success(let leagues):
          print(leagues)
      case .failure(let error):
        if error is NetworkError {
          print(error)
        } else {
          print(error.localizedDescription)
        }
      }
    }
  }

  var leagues: [LeagueResponse] = []
  var leaguesCount: Int { leagues.count }

  func fetchLeagues(completion: @escaping () -> Void) {
    let parser = JSONParser<LeagueResult>()

    let urlBuilder = URLBuilder()
    let urlRequest = urlBuilder.with(endPoint: .leagues).urlRequest

    parser.fetch(urlRequest: urlRequest) { result in
      switch result {
      case .success(let leagues):
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.leagues = leagues.response
          completion()
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

  func leagueCellViewModel(for indexPath: IndexPath) -> LeagueCellViewModelProtocol {
    let leagueResponse = leagues[indexPath.row]
    return LeagueCellViewModel(league: leagueResponse.league)
  }

}
