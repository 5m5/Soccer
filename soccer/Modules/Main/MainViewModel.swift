//
//  MainViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
  var leagues: [League] { get }
  var leaguesCount: Int { get }
  func fetchLeagues(completion: @escaping () -> Void)
  func leagueCellViewModel(for indexPath: IndexPath) -> LeagueCellViewModelProtocol
}

final class MainViewModel: MainViewModelProtocol {

  var leagues: [League] = []
  var leaguesCount: Int { leagues.count }

  func fetchLeagues(completion: @escaping () -> Void) {
    let parser = JSONParser<LeagueResponse>()

    let urlBuilder = URLBuilder()
    guard let url = urlBuilder.with(endPoint: .leagues).url else { return }

    parser.fetch(url: url) { result in
      switch result {
      case .success(let leagues):
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.leagues = leagues.result
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
    let league = leagues[indexPath.row]
    return LeagueCellViewModel(league: league)
  }

}
