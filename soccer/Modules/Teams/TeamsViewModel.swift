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
  var teamsCount: Int { get }
  var teams: [TeamResponse] { get }
  func searchTeams(name: String, completion: @escaping () -> Void)
  func fetchTeamsFromDataBase(completion: @escaping () -> Void)
  func teamCellViewModel(for indexPath: IndexPath) -> TeamCellViewModelProtocol
  func tableView(didSelectRowAt indexPath: IndexPath)
}

// MARK: - Implementation
final class TeamsViewModel: TeamsViewModelProtocol {
  weak var coordinator: TeamsCoordinator?

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

  func fetchTeamsFromDataBase(completion: @escaping () -> Void) {
    CoreDataController.shared.teams { [weak self] teamsMO in
      guard let self = self else { return }
      self.teams = []
      
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

        if let stadiumMO = $0.stadium {
          let stadium = Stadium(
            id: Int(stadiumMO.id),
            name: stadiumMO.name,
            address: stadiumMO.address,
            city: stadiumMO.city
          )

          self.teams.append(TeamResponse(team: team, stadium: stadium, players: players))
          completion()
        }
      }
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
    CoreDataController.shared.saveTeam(response: teamResponse)
    coordinator?.tableViewCellTapped(teamResponse: teamResponse)
  }

}
