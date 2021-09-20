//
//  TeamsViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 14.09.2021.
//

import Foundation

// MARK: - Protocol
protocol TeamsViewModelProtocol: AnyObject {
  var coordinator: TeamsCoordinator? { get }
  var title: String { get }
  var teamsCount: Int { get }
  var teams: [TeamResponse] { get }
  var isTableViewCanEditRow: Bool { get }
  var isTableViewHidden: Bool { get }
  func searchTeams(name: String, completion: @escaping () -> Void)
  func fetchTeamsFromDataBase(completion: @escaping () -> Void)
  func teamCellViewModel(for indexPath: IndexPath) -> TeamCellViewModelProtocol
  func tableView(didSelectRowAt indexPath: IndexPath)
  func removeRow(indexPath: IndexPath)
}

// MARK: - Implementation
final class TeamsViewModel: TeamsViewModelProtocol {
  weak var coordinator: TeamsCoordinator?

  var title = "Teams"

  var teamsCount: Int { teams.count }
  var teams: [TeamResponse] = []

  var isTableViewCanEditRow = false
  var isTableViewHidden: Bool { teamsCount == 0 }

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
          self.isTableViewCanEditRow = false
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

  func fetchTeamsFromDataBase(completion: @escaping () -> Void) {
    CoreDataService.shared.teams { [weak self] teamsMO in
      guard let self = self else { return }
      var teamResponseArray: [TeamResponse] = []

      teamsMO.forEach {
        let team = Team(
          id: Int($0.id),
          name: $0.name ?? "",
          country: $0.country,
          logo: $0.logoPath ?? "",
          winner: nil
        )

        var players: [Player] = []
        if let playersMO = $0.players as? Set<MOPlayer> {
          playersMO.forEach { playerMO in
            let player = Player(
              id: Int(playerMO.id),
              name: playerMO.name,
              age: Int(playerMO.age),
              number: Int(playerMO.number),
              position: playerMO.position,
              photo: playerMO.photoPath
            )

            players.append(player)
          }
        }

        var stadium = Stadium(id: nil, name: nil, address: nil, city: nil)

        if let stadiumMO = $0.stadium {
          stadium = Stadium(
            id: Int(stadiumMO.id),
            name: stadiumMO.name,
            address: stadiumMO.address,
            city: stadiumMO.city
          )
        }

        teamResponseArray.append(TeamResponse(team: team, stadium: stadium, players: players))
      }

      self.isTableViewCanEditRow = true
      self.teams = teamResponseArray
      completion()

    }
  }

  func teamCellViewModel(for indexPath: IndexPath) -> TeamCellViewModelProtocol {
    let team = teams[indexPath.row].team
    return TeamCellViewModel(team: team)
  }

  func tableView(didSelectRowAt indexPath: IndexPath) {
    let index = indexPath.row
    let teamResponse = teams[index]

    precondition(coordinator != nil, "Coordinator should not be nil")
    CoreDataService.shared.saveTeam(response: teamResponse)
    coordinator?.tableViewCellTapped(teamResponse: teamResponse)
  }

  func removeRow(indexPath: IndexPath) {
    let i = indexPath.row
    let team = teams[i].team
    CoreDataService.shared.removeTeam(id: team.id)
    teams.remove(at: i)
  }

}
