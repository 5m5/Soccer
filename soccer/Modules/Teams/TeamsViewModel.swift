//
//  TeamsViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 14.09.2021.
//

import Foundation

// MARK: - Protocol
protocol TeamsViewModelProtocol: AnyObject {
  var teamsCount: Int { get }
  var teams: [TeamResponse] { get }
  func searchTeams(name: String, completion: @escaping () -> Void)
  func teamCellViewModel(for indexPath: IndexPath) -> TeamCellViewModelProtocol
}

// MARK: - Implementation
final class TeamsViewModel: TeamsViewModelProtocol {
  var teamsCount: Int { teams.count }
  var teams: [TeamResponse] = []

  func searchTeams(name: String, completion: @escaping () -> Void) {
    let parser = JSONParser<TeamResult>()
    let urlRequest = EndPointFactory().teams().with(name: name).urlRequest

    parser.fetch(urlRequest: urlRequest) { result in
      switch result {
      case .success(let result):
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          let teams = result.response
          self.teams = teams
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

  func teamCellViewModel(for indexPath: IndexPath) -> TeamCellViewModelProtocol {
    let team = teams[indexPath.row].team
    return TeamCellViewModel(team: team)
  }

}
